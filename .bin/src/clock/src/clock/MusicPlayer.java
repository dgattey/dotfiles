package clock;

import java.io.File;
import java.io.IOException;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.FloatControl;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;
import javax.sound.sampled.UnsupportedAudioFileException;

/**
 * Load and plays a longer music file than a Sound. Good for background music. Volume is constant, but starting and
 * stopping the thread can pause and resume playback. Does not currently support looping sound, but I'm working on it.
 * 
 * @author Sawyer
 */
public class MusicPlayer extends Thread {
	
	private final String		file;
	private volatile boolean	soundPaused	= false;
	
	public MusicPlayer(final String file) {
		this.file = file;
	}
	
	@Override
	public void run() {
		SourceDataLine soundLine = null;
		final int BUFFER_SIZE = 64 * 1024; // 64 KB
		
		// Set up an audio input stream piped from the sound file.
		try {
			while (!Thread.currentThread().isInterrupted()) {
				final File soundFile = new File(file);
				final AudioInputStream audioInputStream = AudioSystem.getAudioInputStream(soundFile);
				final AudioFormat audioFormat = audioInputStream.getFormat();
				final DataLine.Info info = new DataLine.Info(SourceDataLine.class, audioFormat);
				soundLine = (SourceDataLine) AudioSystem.getLine(info);
				soundLine.open(audioFormat);
				if (soundLine.isControlSupported(FloatControl.Type.MASTER_GAIN)) {
					final FloatControl volume = (FloatControl) soundLine.getControl(FloatControl.Type.MASTER_GAIN);
					volume.setValue(-0.5F);
				}
				soundLine.start();
				int nBytesRead = 0;
				final byte[] sampledData = new byte[BUFFER_SIZE];
				while (nBytesRead != -1) {
					if (!soundPaused) {
						if (!soundLine.isActive()) {
							soundLine.start();
						}
						nBytesRead = audioInputStream.read(sampledData, 0, sampledData.length);
						if (nBytesRead >= 0) {
							// Writes audio data to the mixer via this source data line.
							soundLine.write(sampledData, 0, nBytesRead);
						}
					} else {
						soundLine.stop();
					}
				}
			}
		} catch (final UnsupportedAudioFileException | LineUnavailableException | IOException ex) {
			System.err.println("Error in playing music: " + ex.getMessage());
		}
		finally {
			if (soundLine != null) {
				soundLine.drain();
				soundLine.close();
			}
		}
	}
	
	public void pause(final boolean pstatus) {
		soundPaused = pstatus;
	}
}
