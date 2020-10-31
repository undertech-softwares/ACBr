﻿using System;
using System.ComponentModel;
using System.Drawing;
using System.Threading;
using System.Windows.Forms;

namespace ACBrLib
{
    public class SplashScreenManager : IFluentInterface
    {
        #region Fields

        private Form splashForm;
        private bool isShowning;

        #endregion Fields

        #region Properties

        public static SplashScreenManager Default { get; protected set; }

        public Type SplashForm { get; }

        public Form Owner { get; }

        public Thread Thread { get; private set; }

        #endregion Properties

        #region Constructors

        private SplashScreenManager(Type form, Form owner)
        {
            SplashForm = form;
            Owner = owner;
        }

        #endregion Constructors

        #region Methods

        private void ShowForm()
        {
            isShowning = false;

            Thread = new Thread(() =>
            {
                splashForm = (Form)Activator.CreateInstance(SplashForm);
                splashForm.FormBorderStyle = FormBorderStyle.None;
                splashForm.SizeGripStyle = SizeGripStyle.Hide;
                splashForm.StartPosition = Owner != null ? FormStartPosition.Manual : FormStartPosition.CenterScreen;
                splashForm.ShowInTaskbar = false;
                splashForm.Shown += (sender, args) => isShowning = true;

                if (Owner != null)
                {
                    var offset = Owner.OwnedForms.Length * 38;  // approx. 10mm
                    splashForm.Location = new Point(Owner.Left + Owner.Width / 2 - splashForm.Width / 2 + offset,
                        Owner.Top + Owner.Height / 2 - splashForm.Height / 2 + offset);
                }

                splashForm.ShowDialog();
                splashForm.FormClosed += (sender, args) =>
                {
                    Thread?.Abort();
                    Thread = null;
                    splashForm = null;
                };
            });

            Thread.SetApartmentState(ApartmentState.STA);
            Thread.IsBackground = true;
            Thread.Start();

            Application.DoEvents();
        }

        private void CloseForm()
        {
            try
            {
                if (!splashForm.InvokeRequired)
                    splashForm.Close();
                else
                    splashForm.Invoke(new Action(splashForm.Close));
            }
            catch (Exception)
            {
                //
            }
        }

        public void ShowInfo(SplashInfo tipo, params object[] args)
        {
            if (splashForm == null) throw new ApplicationException("SplashScreen não está sendo exibida.");

            if (!splashForm.InvokeRequired)
            {
                ((ISplash)SplashForm).ShowInfo(tipo, args);
            }
            else
            {
                splashForm.Invoke(new Action(() => ((ISplash)splashForm).ShowInfo(tipo, args)));
            }
        }

        public static void Show<T>(bool thowIfRunning = false) where T : Form, ISplash
        {
            Show<T>(null, thowIfRunning);
        }

        public static void Show<T>(Form owner, bool thowIfRunning = false) where T : Form, ISplash
        {
            if (Default != null && !thowIfRunning) return;
            if (Default != null) throw new ApplicationException("SplashScreen já está sendo exibida.");

            Default = new SplashScreenManager(typeof(T), owner);
            Default.ShowForm();
            while (!Default.isShowning) { Thread.Sleep(500); }
        }

        public static void Close(bool thowIfNotRunning = false)
        {
            if (Default == null && !thowIfNotRunning) return;
            if (Default == null) throw new ApplicationException("SplashScreen não está sendo exibida.");

            Default.CloseForm();
            Default = null;
            User32.CleanBuffers();
        }

        #endregion Methods
    }

    [EditorBrowsable(EditorBrowsableState.Never)]
    public interface IFluentInterface
    {
        /// <summary>
        /// Redeclaration that hides the <see cref="object.GetType()"/> method from IntelliSense.
        /// </summary>
        [EditorBrowsable(EditorBrowsableState.Never)]
        Type GetType();

        /// <summary>
        /// Redeclaration that hides the <see cref="object.GetHashCode()"/> method from IntelliSense.
        /// </summary>
        [EditorBrowsable(EditorBrowsableState.Never)]
        int GetHashCode();

        /// <summary>
        /// Redeclaration that hides the <see cref="object.ToString()"/> method from IntelliSense.
        /// </summary>
        [EditorBrowsable(EditorBrowsableState.Never)]
        string ToString();

        /// <summary>
        /// Redeclaration that hides the <see cref="object.Equals(object)"/> method from IntelliSense.
        /// </summary>
        [EditorBrowsable(EditorBrowsableState.Never)]
        bool Equals(object obj);
    }
}