package clock;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.DateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import javax.swing.text.DateFormatter;

/**
 * Sets an alarm for the passed in time
 * 
 * @author dgattey
 */
public class Alarm {
	
	private static final String					MUSIC_FILE	= "/Users/dgattey/.bin/equinox.wav";
	private static final int					MAX_ALARMS	= 20;
	private static ScheduledThreadPoolExecutor	executor;
	private static BufferedReader				reader;
	private static DateFormatter				formatter;
	private static Map<Date, Thread>			allAlarms;
	private static MusicPlayer					currentAlarm;
	
	/**
	 * Runs the alarm loop
	 * 
	 * @param args ignored
	 */
	public static void main(final String[] args) {
		executor = new ScheduledThreadPoolExecutor(MAX_ALARMS);
		executor.allowCoreThreadTimeOut(false);
		reader = new BufferedReader(new InputStreamReader(System.in));
		formatter = new DateFormatter(DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT));
		allAlarms = new HashMap<>(MAX_ALARMS);
		
		printWelcome();
		while (true) {
			try {
				final String input = reader.readLine();
				parseInput(input);
			} catch (final IOException e) {
				executor.shutdownNow();
				System.out.println("Exiting now");
				System.exit(0);
			}
			System.out.println();
		}
	}
	
	/**
	 * Parses input
	 * 
	 * @param input the user's input
	 * @throws IOException if problem found
	 */
	private static void parseInput(final String input) throws IOException {
		final int addL = "add ".length();
		final int removeL = "remove ".length();
		
		// Exiting
		if (input == null || input.isEmpty() || input.equals("quit") || input.equals("exit")) {
			throw new IOException("exit");
		}
		
		// Other input
		final int inputL = input.length();
		if (input.equals("alarms")) {
			printAlarms();
		} else if (input.startsWith("add ") && inputL > addL) {
			final String dateString = input.substring(addL, inputL);
			addAlarm(stringToDate(dateString));
		} else if (input.startsWith("remove ") && inputL > removeL) {
			final String dateString = input.substring(removeL, inputL);
			removeAlarm(stringToDate(dateString));
		} else if (input.equals("stop") && currentAlarm != null) {
			currentAlarm.pause(true);
			currentAlarm = null;
			System.out.println("Alarm stopped!");
		} else {
			System.out.println("Command invalid! Try again");
		}
	}
	
	/**
	 * Prints out a welcome message
	 */
	private static void printWelcome() {
		System.out.println("***");
		System.out.println("* Hello! Enter one of the following commands. Set up to " + MAX_ALARMS + " alarms.");
		System.out.println("* \"add m/d/y h:m\" a to add an alarm");
		System.out.println("* \"remove m/d/y h:m\" a to remove an alarm");
		System.out.println("* \"alarms\" to print current alarms");
		System.out.println("* \"stop\" to stop a ringing alarm");
		System.out.println("* \"exit\" or \"quit\" to quit");
		System.out.println("* Current time is: " + dateToString(new Date()));
		System.out.println("***\n");
	}
	
	/**
	 * Prints all alarms to console
	 */
	private static void printAlarms() {
		System.out.println("The current time is: " + dateToString(new Date()));
		if (currentAlarm != null) {
			System.out.println("An alarm is currently sounding - to stop, type \"stop\"");
		}
		for (final Date d : allAlarms.keySet()) {
			System.out.println("Alarm set for " + dateToString(d));
		}
		System.out.println((MAX_ALARMS - allAlarms.size()) + " alarms left");
	}
	
	/**
	 * Schedules an alarm for the given date (and checks arguments too)
	 * 
	 * @param dueDate a date for the alarm
	 * @return if the scheduling was fine
	 */
	private static boolean addAlarm(final Date dueDate) {
		if (dueDate == null) {
			System.out.println("That date wasn't valid. Try again.");
			return false;
		} else if (allAlarms.containsKey(dueDate)) {
			System.out.println("Alarm already exists for that date/time! Try again.");
			return false;
		}
		
		// Schedule music to be played
		final long diff = dueDate.getTime() - new Date().getTime();
		final Thread thread = new MusicPlayer(MUSIC_FILE) {
			
			@Override
			public void run() {
				allAlarms.remove(dueDate); // takes this out of the alarms map
				if (currentAlarm != null) {
					currentAlarm.pause(true);
					currentAlarm.interrupt();
					currentAlarm = null;
				}
				currentAlarm = this;
				System.out.println("Alarm for " + dateToString(dueDate) + " is sounding!\n");
				super.run(); // plays music
				
			}
		};
		allAlarms.put(dueDate, thread);
		executor.schedule(thread, diff, TimeUnit.MILLISECONDS);
		System.out.println("Alarm added for " + dateToString(dueDate));
		return true;
	}
	
	/**
	 * Removes an alarm at dueDate if it exists
	 * 
	 * @param dueDate the date at which an alarm may be set
	 * @return if it was successfully removed
	 */
	private static boolean removeAlarm(final Date dueDate) {
		if (dueDate == null) {
			System.out.println("That date wasn't valid. Try again.");
			return false;
		}
		if (allAlarms.containsKey(dueDate)) {
			allAlarms.get(dueDate).interrupt();
			allAlarms.remove(dueDate);
			System.out.println("Alarm for " + dateToString(dueDate) + "removed");
		} else {
			System.out.println("No alarm for that input existed. Try again");
		}
		return true;
	}
	
	/**
	 * Takes a string for a date and tries to parse it
	 * 
	 * @param date the date for alarm
	 * @return a Date object representing the date
	 */
	private static Date stringToDate(final String date) {
		try {
			final DateFormat form = DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT);
			return form.parse(date);
		} catch (final ParseException e1) {
			return null;
		}
	}
	
	/**
	 * Returns a date as a string
	 * 
	 * @param d date to parse
	 * @return string representation of d
	 */
	private static String dateToString(final Date d) {
		String date = "";
		try {
			date = formatter.valueToString(d);
		} catch (final ParseException e) {
			System.err.println("FAILURE: date to string failed. Exiting now");
			System.exit(1);
		}
		return date;
	}
}
