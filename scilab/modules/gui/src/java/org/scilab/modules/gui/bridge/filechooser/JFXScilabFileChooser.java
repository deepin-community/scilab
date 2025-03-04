/*
 * Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2021-2022 - Stéphane MOTTELET
 *
 * This file is hereby licensed under the terms of the GNU GPL v3.0,
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

package org.scilab.modules.gui.bridge.filechooser;

import java.io.File;
import java.util.StringTokenizer;
import java.util.concurrent.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Optional;

import java.awt.Toolkit;
import java.awt.Dimension;
import java.awt.Robot;


import javafx.collections.ObservableList;
import javafx.application.Platform;
import javafx.embed.swing.JFXPanel;
import javafx.stage.Stage;
import javafx.stage.Modality;
import javafx.stage.StageStyle;
import javafx.stage.FileChooser;
import javafx.stage.FileChooser.ExtensionFilter;
import javafx.stage.DirectoryChooser;
import javafx.stage.StageStyle;

import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import javax.swing.filechooser.FileFilter;
import javax.swing.filechooser.FileNameExtensionFilter;

import org.scilab.modules.gui.filechooser.FileChooserInfos;
import org.scilab.modules.gui.filechooser.SimpleFileChooser;
import org.scilab.modules.gui.utils.ConfigManager;
import org.scilab.modules.gui.utils.SciFileFilter;
import org.scilab.modules.gui.utils.ScilabSwingUtilities;
import org.scilab.modules.localization.Messages;

/**
 * JavaFX implementation of a Scilab File Chooser
 * @author Stéphane Mottelet
 */

public class JFXScilabFileChooser implements SimpleFileChooser {
    private static final long serialVersionUID = 1L;
    public static final int OPEN_DIALOG = 0;
    public static final int SAVE_DIALOG = 1;
    private String[] selection; // Path + filenames
    private String selectionPath; // Path
    private String title;
    private static Double xPos = Double.NaN;
    private static Double yPos = Double.NaN;
    private String[] selectionFileNames; // Filenames
    private int selectionSize;
    private int filterIndex;
    private int maskSize = 0;
    private boolean acceptAllFileFilterUsed = false;
    private int dialogType = 0;
    private boolean directorySelectionOnly = false;
    private boolean multipleSelection = false;
    private JFXPanel jfxpanel = new JFXPanel();
    private DirectoryChooser directoryChooser;
    private FileChooser fileChooser;
    private Stage stage;


    public JFXScilabFileChooser() {
        directoryChooser = new DirectoryChooser();
        fileChooser = new FileChooser();
    }

    class getChosenFile implements Callable<ArrayList<File>> {
        @Override public ArrayList<File> call() throws Exception {
            // This method is invoked on the JavaFX thread
            ArrayList<File> theResult = new ArrayList<File>();
            
            if (!(stage instanceof Stage)) {
                stage = new Stage();
                stage.setMaxHeight(0);
                stage.setWidth(0);
                stage.setResizable(false);
                stage.setAlwaysOnTop(true);
                stage.initStyle(StageStyle.UNIFIED);
                if (xPos.isNaN()) {
                    Dimension d = Toolkit.getDefaultToolkit().getScreenSize(); // get screen size
                    xPos = d.width/2-stage.getWidth()/2;
                    yPos = (double)d.height/3;
                }
                stage.setX(xPos);
                stage.setY(yPos);                    
            }
            stage.setTitle(title);
            stage.initModality(Modality.APPLICATION_MODAL); 
            stage.show(); //show stage because you wouldn't be able to get Height & width of the stage
                
            if (dialogType == JFXScilabFileChooser.OPEN_DIALOG) {
                if (multipleSelection == false) {
                    if (directorySelectionOnly == false)  {
                        File aFile = fileChooser.showOpenDialog(stage);
                        if (aFile != null) {
                            theResult.add(aFile);
                        }
                    } else {
                        File aFile = directoryChooser.showDialog(stage);
                        if (aFile != null) {
                            theResult.add(aFile);
                        }
                    }
                } else {
                    List<File> files = fileChooser.showOpenMultipleDialog(stage);
                    if (files != null) {
                        for (int i=0; i<files.size(); i++) {
                            theResult.add(files.get(i));
                        }
                    }
                }
            } else if (dialogType == JFXScilabFileChooser.SAVE_DIALOG) {
                String fileName = fileChooser.getInitialFileName();
                if (fileName != null && fileName != "")
                {
                    Boolean found = false;
                    int index = fileName.lastIndexOf('.');
                    ExtensionFilter filter = null;
                    if(index > 0) {
                        String extension = "*"+fileName.substring(index);
                        filter = getFileFilterFromExtension(extension);
                        if (filter != null) {
                            fileChooser.setSelectedExtensionFilter(filter);
                        }
                    }
                    if (filter == null) {
                         if (acceptAllFileFilterUsed) {
                             filter = getFileFilterFromExtension("*.*");
                             if (filter != null) {
                                 fileChooser.setSelectedExtensionFilter(filter);
                             }
                         }
                     } 
                }
                
                File aFile  = fileChooser.showSaveDialog(stage);
                if (aFile != null) {
                    theResult.add(aFile);
                }
            }
            xPos = stage.getX();
            yPos = stage.getY();
            stage.close();
            
            return theResult;
        }
    }

    /**
     * Set the parent frame
     * @param parent the parent frame
     */
    public void setParentFrame(JFrame parent) {
    }

    /**
     * Display this chooser and wait for user selection
     */
    public void displayAndWait() {
        FutureTask<ArrayList<File>> futureTask = new FutureTask<ArrayList<File>>(
          new getChosenFile()
        );
        Platform.setImplicitExit(false);
        Platform.runLater(futureTask);
        try {
            ArrayList<File> result = futureTask.get();
            selectionSize = result.size();
            if (selectionSize > 0) {
                selection = new String[selectionSize];
                selectionFileNames = new String[selectionSize];
                for (int i=0; i<result.size(); i++) {
                    selection[i] = result.get(i).getAbsolutePath();
                    selectionPath = result.get(i).getParentFile().getPath();
                    selectionFileNames[i] = result.get(i).getName();
                }
                filterIndex = getSelectedFilterIndex()+1;
            } else {
                // Cancel case
                selection = new String[1];
                selection[0] = "";
                selectionPath = "";
                selectionFileNames = new String[1];
                selectionFileNames[0] = "";
                filterIndex = 0;
            }
            
            //return the filechooser's information
            //they are stocked into FileChooserInfos
            FileChooserInfos.getInstance().setSelection(selection);
            FileChooserInfos.getInstance().setSelectionPathName(selectionPath);
            FileChooserInfos.getInstance().setSelectionFileNames(selectionFileNames);
            FileChooserInfos.getInstance().setSelectionSize(selectionSize);
            FileChooserInfos.getInstance().setFilterIndex(filterIndex);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void setAcceptAllFileFilterUsed(boolean flag) {
        acceptAllFileFilterUsed = flag;
        if (flag == true)  {
            SciFileFilter filter = new SciFileFilter("*.*",null, 0);        
            fileChooser.getExtensionFilters().add(new FileChooser.ExtensionFilter(filter.getDescription(),"*.*"));
        }
    }

    /**
     * Set the mask & the mask description for the filechooser
     * @param mask the mask to set
     * @param fileMaskDescription the maskDescription to set
     */
    public void addMask(String[] theMask, String[] theFileMaskDescription) {

        if (theFileMaskDescription == null || theFileMaskDescription.length == 0) {
            for (int i=0; i<theMask.length; i++) {
                SciFileFilter filter = new SciFileFilter(theMask[i], null, i);
                fileChooser.getExtensionFilters().add(new FileChooser.ExtensionFilter(filter.getDescription(),Arrays.asList(theMask[i].split("\\|"))));
                if (theMask[i].equals("*.*"))
                {
                     acceptAllFileFilterUsed = true;
                }
            }
        } else {
            for (int i=0; i<theMask.length; i++) {
                SciFileFilter filter = new SciFileFilter(theMask[i], theFileMaskDescription[i], i);
                fileChooser.getExtensionFilters().add(new FileChooser.ExtensionFilter(filter.getDescription(),Arrays.asList(theMask[i].split("\\|"))));
                if (theMask[i].equals("*.*"))
                {
                     acceptAllFileFilterUsed = true;
                }
            }
        }
    }

    public void setFileFilter(FileChooser.ExtensionFilter filter) {
        fileChooser.setSelectedExtensionFilter(filter);
    }

     public void setFileFilter(FileFilter filter) {
         String[] ext = ((FileNameExtensionFilter) filter).getExtensions();
         for (int i=0; i<ext.length; i++) {
             ext[i]="*."+ext[i];
         }
         fileChooser.setSelectedExtensionFilter(new FileChooser.ExtensionFilter(((FileNameExtensionFilter)filter).getDescription(),ext));
     }

     public ExtensionFilter getFileFilterFromExtension(String extension) {
        for (ExtensionFilter filter : fileChooser.getExtensionFilters())   
        {
            for (String filtext : filter.getExtensions())
            {
                if (filtext.equals(extension))
                {                                    
                    return filter;
                }
            }
        }
        return null;
    }

    public int getSelectedFilterIndex() {
       int k = 0;
       for (ExtensionFilter filter : fileChooser.getExtensionFilters()) {
           if (fileChooser.getSelectedExtensionFilter() == filter) {
               return k;
           }
           k = k+1;
       }
       return -1;
   }

    public void setTitle(String string) {
        title = string;
    }

    public void setCurrentDirectory(File file) {
        File dir;
        if (file.isDirectory()) {
            dir = file;
        } else if (file.exists()) {
            dir = file.getParentFile();       
        } else
        {
            dir = new File(System.getProperty("user.dir"));
        }
        if (directorySelectionOnly == true)  {
             directoryChooser.setInitialDirectory(dir);
        } else {
             fileChooser.setInitialDirectory(dir);
        }
    }

    public void setInitialDirectory(String path) {
        // When empty string given
        if (path == null || path.length() == 0) {
            return;
        }
        // Replace beginning of the path if is an environment variable
        String newPath = path;
        StringTokenizer tok = new StringTokenizer(path, File.separator);
        if (tok.hasMoreTokens()) {
            /* It is possible that we don't have any more token here when
                                          Scilab is started from / for example */
            String firstToken = tok.nextToken();
            if (firstToken != null && System.getenv(firstToken) != null)  {
                newPath = newPath.replaceFirst(firstToken, System.getenv(firstToken));
            }
        }
        setCurrentDirectory(new File(newPath));
    }

    public void setInitialFileName(String path) {
        if (path == null || path.length() == 0) {
            return;
        }
        File file = new File(path);
        fileChooser.setInitialFileName(file.getName());
     }

    /**
     * Get the number of files selected
     * @return the number of files selected
     */
    public int getSelectionSize() {
        return selectionSize;
    }

    /**
     * Get the names of selected files
     * @return the names of selected files
     */
    public String[] getSelection() {
        return selection;
    }

    /**
     * Set the flag indicating that we want only select directories
     */
    public void setDirectorySelectionOnly() {
        directorySelectionOnly = true;
    }

    /**
     * Set the flag indicating that we can select multiple files
     * @param multipleSelection enable multiple selection
     */
    public void setMultipleSelection(boolean flag)
    {
        multipleSelection = flag;
    }

    /**
     * Get the path of selected files
     * @return the path of selected files
     */
    public String getSelectionPathName() {
        return selectionPath;
    }

    /**
     * Get the names of selected files
     * @return the names of selected files
     */
    public String[] getSelectionFileNames(){
        return selectionFileNames;
    }

    public void invalidate() {
    }

    /**
     * Set the dialog type (save or open a file ?)
     * @param dialogType the dialog type
     */
    public void setUiDialogType(int type)
    {
        // LOAD = 0, SAVE = 1
        dialogType = type;
    }

}
