﻿using System;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace ACBrLib
{
    public static class Helpers
    {
        public static string OpenFile(string filters, string title = "Abrir", bool checkFileExists = true)
        {
            using (var ofd = new OpenFileDialog())
            {
                ofd.CheckPathExists = true;
                ofd.CheckFileExists = checkFileExists;
                ofd.Multiselect = false;
                ofd.Filter = filters;
                ofd.Title = title;

                return ofd.ShowDialog().Equals(DialogResult.Cancel) ? null : ofd.FileName;
            }
        }

        public static string[] OpenFiles(string filters, string title = "Abrir")
        {
            using (var ofd = new OpenFileDialog())
            {
                ofd.CheckPathExists = true;
                ofd.CheckFileExists = true;
                ofd.Multiselect = true;
                ofd.Filter = filters;
                ofd.Title = title;

                return ofd.ShowDialog().Equals(DialogResult.Cancel) ? null : ofd.FileNames;
            }
        }

        public static string SaveFile(string filters, string title = "Salvar")
        {
            using (var ofd = new SaveFileDialog())
            {
                ofd.CheckPathExists = true;
                ofd.Filter = filters;
                ofd.Title = title;

                return ofd.ShowDialog().Equals(DialogResult.Cancel) ? null : ofd.FileName;
            }
        }

        public static string SelectFolder(string initialPath = "")
        {
            using (var fbd = new FolderBrowserDialog())
            {
                if (!string.IsNullOrEmpty(initialPath)) fbd.SelectedPath = initialPath;
                fbd.ShowNewFolderButton = true;
                return fbd.ShowDialog().Equals(DialogResult.Cancel) ? string.Empty : fbd.SelectedPath;
            }
        }
    }
}