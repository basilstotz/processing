/**
 * Sketch Outline provides a tree view of your sketch and its 
 * members functions, variables and inner classes. Clicking on any 
 * node moves the cursor to its definition.
 *
 * Copyright (c) 2012 Manindra Moharana
 *
 * ##copyright##
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 *  
 * 
 * @author	Manindra Moharana	##author##
 * @modified 19-03-2012			##date##
 * @version 0.1.5 (beta)		##version##
 */
package sketchoutline.tool;


import javax.swing.*;
import javax.swing.tree.*;
import processing.app.Editor;


/**
 * Implements {@link TreeMaker} using multi threading. Used for the auto refresh
 * functionality. The code tree is rebuilt every few seconds and this process
 * takes place in a separate thread so the the main editor thread focuses solely
 * on the editor and its performance isn't affected. Used by
 * {@link SketchOutlineFrame}
 * 
 */
public class ThreadedTreeMaker implements Runnable {

	TreeMaker treeMaker;
	/**
	 * If this flag is true, auto refresh stops updating but the thread still
	 * runs.
	 */
	boolean stop = false;
	Thread thread;
	SketchOutlineFrame frame = null;
	TreePath lastpath = null;
	public int lastRow = -1;
	public final int fastTime = 1000, slowSleep = 3000;
	int sleepDuration;
	int buildCount = 1;

	public void run() {

		while (true) {
			
			// If stop flag is set, don't execute
			if (stop)
				break;
			
			try {
				Thread.sleep(sleepDuration);
				
				// Update the tree only if sketch is modified
				if (treeMaker.editor != null) {
					if (treeMaker.editor.getSketch().getCurrentCode()
							.isModified()) {
						// System.out.println("Editor modified");
						updateTree();
					} else {
						// System.out.println("Editor NOT modified");
						continue;
					}
				}
			} catch (InterruptedException e) {
				System.err.println("ThreadedTreeMaker Interrupted! :(");
				if (TreeMaker.debugMode)
					e.printStackTrace();
			} catch (Exception e) {
				System.err
						.println("Some exception caught in ThreadedTreeMaker: "
								+ e.toString());
				if (TreeMaker.debugMode)
					e.printStackTrace();
			}
		}

	}

	/**
	 * Refreshes the code tree
	 * 
	 * @return boolean - true if updated successfully
	 */
	public boolean updateTree() {
		try {
			if (treeMaker.buildTree()) {

				SwingWorker worker = new SwingWorker() {

					@Override
					protected Object doInBackground() throws Exception {
						return null;
					}

					protected void done() {
						frame.tree.setModel(new DefaultTreeModel(getTree()));
						((DefaultTreeModel) frame.tree.getModel()).reload();

						// Expand trees only if user is not interacting with the
						// frame
						if (!frame.hasFocus()) {
							for (int i = 0; i < frame.tree.getRowCount(); i++) {
								frame.tree.expandRow(i);
							}

							if (lastRow >= 0) {
								// frame.tree.expandRow(lastRow);
								frame.tree.setSelectionRow(lastRow);
								// frame.tree.
								// System.out.println("Row expand.");
							}
							if (lastRow < 0) {
								frame.tree.setSelectionRow(0);
							}
						}
						frame.tree.validate();
						if (TreeMaker.debugMode)
							System.out.println("Outline Refreshed.");

					}
				};
				worker.execute();
				return true;
			}

			else {
				if (TreeMaker.debugMode)
					System.out.println("Outline not refreshed.");
				
			}
		} catch (Exception e) {
			System.err
					.println("Some exception caught in ThreadedTreeMaker: updateTree() "
							+ e.toString());
			if (TreeMaker.debugMode)
				e.printStackTrace();
		}
		return false;
	}

	public ThreadedTreeMaker() {
		treeMaker = new TreeMaker();

	}

	public ThreadedTreeMaker(String path) {
		treeMaker = new TreeMaker(path);

	}

	public ThreadedTreeMaker(SketchOutlineFrame frame, Editor editor) {
		treeMaker = new TreeMaker(editor);
		this.frame = frame;

	}

	public ThreadedTreeMaker(String path, SketchOutlineFrame frame) {
		treeMaker = new TreeMaker(path);
		this.frame = frame;

	}

	public DefaultMutableTreeNode getTree() {
		return treeMaker.getCodeTree();
	}

	/**
	 * Stops the auto refresh thread.
	 */
	public void halt() {
		if (thread == null)
			return;
		thread.stop();
		stop = true;
		System.out.println("Auto refresh OFF.");
	}

	/**
	 * Starts the auto refresh thread.
	 */
	public void start() {
		if (treeMaker.editor == null)
			sleepDuration = slowSleep;
		else
			sleepDuration = fastTime;

		// if (thread == null) {
		// thread = new Thread(this);
		// thread.start();
		// } else
		// thread.resume();
		thread = new Thread(this);
		thread.start();
		stop = false;
		System.out.println("Auto refresh ON.");
	}
}
