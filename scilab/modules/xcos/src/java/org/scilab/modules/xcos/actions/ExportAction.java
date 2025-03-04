/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2009 - DIGITEO - Vincent COUVERT
 * Copyright (C) 2010 - DIGITEO - Clement DAVID
 * Copyright (C) 2011-2015 - Scilab Enterprises - Clement DAVID
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 * Copyright (C) 2022 - Stéphane MOTTELET
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

package org.scilab.modules.xcos.actions;

import java.awt.Color;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;
import java.util.logging.Logger;

import javax.imageio.ImageIO;
import javax.imageio.ImageWriter;
import javax.swing.BorderFactory;
import javax.swing.JFileChooser;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.border.TitledBorder;

import org.scilab.modules.graph.ScilabGraph;
import org.scilab.modules.graph.actions.base.DefaultAction;
import org.scilab.modules.graph.utils.ScilabGraphRenderer;
import org.scilab.modules.gui.menuitem.MenuItem;
import org.scilab.modules.gui.messagebox.ScilabModalDialog;
import org.scilab.modules.gui.messagebox.ScilabModalDialog.AnswerOption;
import org.scilab.modules.gui.messagebox.ScilabModalDialog.ButtonType;
import org.scilab.modules.gui.messagebox.ScilabModalDialog.IconType;
import org.scilab.modules.localization.Messages;
import org.scilab.modules.xcos.XcosTab;
import org.scilab.modules.xcos.configuration.ConfigurationManager;
import org.scilab.modules.xcos.graph.XcosDiagram;
import org.scilab.modules.xcos.utils.XcosMessages;
import org.scilab.modules.gui.filechooser.ScilabFileChooser;
import org.scilab.modules.gui.filechooser.FileChooser;
import org.scilab.modules.gui.filechooser.Juigetfile;

import org.w3c.dom.Document;

import com.mxgraph.swing.mxGraphComponent;
import com.mxgraph.util.mxCellRenderer;
import com.mxgraph.util.mxUtils;
import com.mxgraph.util.mxXmlUtils;

/**
 * Diagram export management
 */
@SuppressWarnings(value = { "serial" })
public final class ExportAction extends DefaultAction {
    /** Name of the action */
    public static final String NAME = XcosMessages.EXPORT;
    /** Icon name of the action */
    public static final String SMALL_ICON = "";
    /** Mnemonic key of the action */
    public static final int MNEMONIC_KEY = KeyEvent.VK_E;
    /** Accelerator key for the action */
    public static final int ACCELERATOR_KEY = Toolkit.getDefaultToolkit().getMenuShortcutKeyMask();

    private static final String HTML = "html";
    private static final String VML = "vml";
    private static final String SVG = "svg";

    /**
     * Constructor
     *
     * @param scilabGraph
     *            associated Scilab Graph
     */
    public ExportAction(ScilabGraph scilabGraph) {
        super(scilabGraph);
    }

    /**
     * Create export menu
     *
     * @param scilabGraph
     *            associated Scilab Graph
     * @return the menu
     */
    public static MenuItem createMenu(ScilabGraph scilabGraph) {
        return createMenu(scilabGraph, ExportAction.class);
    }

    /**
     * Action !!!
     *
     * @param e
     *            parameter
     * @see org.scilab.modules.graph.actions.base.DefaultAction#actionPerformed(java.awt.event.ActionEvent)
     */
    @Override
    public void actionPerformed(ActionEvent e) {

        XcosDiagram graph = (XcosDiagram) getGraph(null);

        // Adds a filter for each supported image format
        Collection<String> imageFormats = Arrays.asList(ImageIO.getWriterFileSuffixes());

        // The mask ordered collection
        Set<String> mask = new TreeSet<String>(String.CASE_INSENSITIVE_ORDER);

        mask.add(SVG);
        mask.add(HTML);
        mask.add(VML);
        mask.addAll(imageFormats);

        FileChooser fc = ScilabFileChooser.createFileChooser();
        fc.setTitle(XcosMessages.EXPORT);
        fc.setUiDialogType(Juigetfile.SAVE_DIALOG);
        String[] exts = new String[mask.size()];
        mask.toArray(exts);
        for (int i=0; i < exts.length; i++) {
            exts[i] = "*." + exts[i];
        }        
        fc.addMask(exts,null);

        ConfigurationManager.configureCurrentDirectory(fc);

        fc.displayAndWait();

        String[] selection = fc.getSelection();
        if (selection.length!=0 && selection[0] != "") {
            String fileName = selection[0];
            int index = fileName.lastIndexOf('.');
            String format = fileName.substring(index+1);
            try {
                export(graph, new File(fileName), format);                
            } catch (IOException ex) {
                Logger.getLogger(ExportAction.class.getName()).severe(e.toString());
            }
        }
    }

    /**
     * Export the graph into the filename.
     *
     * The filename extension is used find export format.
     *
     * @param graph
     *            the current graph
     * @param filename
     *            the filename
     * @param fileFormat
     *            the format to save
     * @throws IOException
     *             when a write problem occurs.
     */
    private void export(XcosDiagram graph, File filename, String fileFormat) throws IOException {
        if (fileFormat.equalsIgnoreCase(SVG)) {
            ScilabGraphRenderer.createSvgDocument(graph, null, 1, null, null, filename.getCanonicalPath());
        } else if (fileFormat.equalsIgnoreCase(VML)) {
            Document doc = mxCellRenderer.createVmlDocument(graph, null, 1, null, null);
            if (doc != null) {
                mxUtils.writeFile(mxXmlUtils.getXml(doc.getDocumentElement()), filename.getCanonicalPath());
            }
        } else if (fileFormat.equalsIgnoreCase(HTML)) {
            Document doc = mxCellRenderer.createHtmlDocument(graph, null, 1, null, null);
            if (doc != null) {
                mxUtils.writeFile(mxXmlUtils.getXml(doc.getDocumentElement()), filename.getCanonicalPath());
            }
        } else {
            exportBufferedImage(graph, filename, fileFormat);
        }
    }

    /**
     * Use the Java image capabilities to export the diagram
     *
     * @param graph
     *            the current diagram
     * @param filename
     *            the current filename
     * @param fileFormat
     *            the file format
     * @throws IOException
     *             when an error occurs
     */
    private void exportBufferedImage(XcosDiagram graph, File filename, String fileFormat) throws IOException {
        final mxGraphComponent graphComponent = graph.getAsComponent();

        Color bg = null;

        if ((!fileFormat.equalsIgnoreCase("png"))
                || ScilabModalDialog
                .show(XcosTab.get(graph), XcosMessages.TRANSPARENT_BACKGROUND, XcosMessages.XCOS, IconType.QUESTION_ICON, ButtonType.YES_NO) != AnswerOption.YES_OPTION) {
            bg = graphComponent.getBackground();
        }

        BufferedImage image = mxCellRenderer.createBufferedImage(graph, null, 1, bg, graphComponent.isAntiAlias(), null, graphComponent.getCanvas());

        if (image != null) {
            ImageIO.write(image, fileFormat, filename);
        } else {
            JOptionPane.showMessageDialog(graphComponent, XcosMessages.NO_IMAGE_DATA);
        }
    }
}
