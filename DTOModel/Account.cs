using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PhanMemQLCafe.DTOModel
{
    public class Account
    {
        public Account(string userName, string name, bool isManager, string password = null)
        {
            this.UserName = userName;
            this.Name = name;
            this.IsManager = isManager;
            this.password = password;
        }

        public Account(DataRow row)
        {
            this.UserName = row["userName"].ToString();
            this.Name = row["Name"].ToString();
            this.IsManager = (bool)row["isManager"];
            this.Password = row["PassWord"].ToString();
        }

        private bool isManager;

        public bool IsManager
        {
            get { return isManager; }
            set { isManager = value; }
        }

        private string password;

        public string Password
        {
            get { return password; }
            set { password = value; }
        }

        private string name;

        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        private string userName;

        public string UserName
        {
            get { return userName; }
            set { userName = value; }
        }
    }
}
