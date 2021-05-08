using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PhanMemQLCafe.DAOModel;
using PhanMemQLCafe.DTOModel;

namespace PhanMemQLCafe.DAOModel
{
    public class AccountDAO
    {
        private static AccountDAO instance;

        public static AccountDAO Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new AccountDAO();
                }
                return instance;
            }

            private set
            {
                instance = value;
            }
        }

        private AccountDAO() { }

        public bool Login(string userName, string password)
        {
            string query = "USP_Login @userName , @password";

            DataTable result = DataProvider.Instance.ExecuteQuery(query, new object[] { userName, password });

            return result.Rows.Count > 0;
        }

        public Account GetAccountByUserName(string userName)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("Select * from Staff where UserName = '" + userName + "' ");

            foreach (DataRow item in data.Rows)
            {
                return new Account(item);
            }
            return null;
        }

        public bool UpdateAccount(string userName, string name, string password, string newPassword)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("EXEC USP_UpdateAccount @userName , @name , @password , @newPassword", new object[] { userName, name, password, newPassword });
            return result > 0;
        }

        public List<Account> GetListAccount()
        {
            List<Account> list = new List<Account>();

            string query = "SELECT * FROM dbo.Staff";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Account account = new Account(item);

                list.Add(account);
            }

            return list;
        }

        public int CheckExistAccount(string userName)
        {
            return (int)DataProvider.Instance.ExecuteScalar("SELECT COUNT(*) FROM dbo.Staff WHERE UserName = '" + userName + "'");

        }

        public bool AddAccount(string userName, string name, int type)
        {
            int count = AccountDAO.Instance.CheckExistAccount(userName);

            if (count == 0)
            {
                string query = string.Format("INSERT dbo.Staff(UserName, Name, isManager) VALUES('{0}', N'{1}', {2})", userName, name, type);
                int result = DataProvider.Instance.ExecuteNonQuery(query);
                return result > 0;
            }
            return false;
        }

        public bool EditAccount(string userName, string name, int type)
        {
            string query = string.Format("UPDATE dbo.Staff SET Name = N'{0}', isManager = {1} WHERE UserName = '{2}'", name, type, userName);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }

        public bool DeleteAccount(string userName)
        {
            string query = string.Format("DELETE FROM dbo.Staff WHERE UserName = '{0}'", userName);
            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool ResetPassword(string userName)
        {
            string query = string.Format("UPDATE dbo.Staff SET PassWord = '1' where UserName = '{0}'", userName);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
    }
}
