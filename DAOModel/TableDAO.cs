using PhanMemQLCafe.DTOModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PhanMemQLCafe.DAOModel
{
    public class TableDAO
    {
        public static TableDAO instance;

        public static TableDAO Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new TableDAO();
                }
                return TableDAO.instance;
            }

            private set
            {
                TableDAO.instance = value;
            }
        }

        public static int TableWidth = 80;
        public static int TableHeight = 80;

        public TableDAO() { }

        public void SwitchTable(int tableID1, int tableID2)
        {
            DataProvider.Instance.ExecuteQuery("USP_SwitchTable @TableID1 , @TableID2 , member1", new object[] { tableID1, tableID2});
        }

        public List<Table> LoadTableList()
        {
            List<Table> tableList = new List<Table>();

            DataTable data = DataProvider.Instance.ExecuteQuery("USP_GetTableList");

            foreach (DataRow item in data.Rows)
            {
                Table table = new Table(item);
                tableList.Add(table);
            }

            return tableList;
        }

        public List<Table> GetListTable()
        {
            List<Table> list = new List<Table>();

            string query = "SELECT * FROM dbo.FoodTable";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Table table = new Table(item);

                list.Add(table);
            }

            return list;
        }

        public int GetTableIDByTableName(string name)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM FoodTable WHERE Name = N'" + name + "' ");

            if (data.Rows.Count > 0)
            {
                Table table = new Table(data.Rows[0]);
                return table.ID;
            }
            return -1;
        }

        public int CheckExistTableName(string name)
        {
            try
            {
                int id = TableDAO.Instance.GetTableIDByTableName(name);
                return (int)DataProvider.Instance.ExecuteScalar("SELECT COUNT(*) FROM dbo.FoodTable WHERE TableID = " + id + "");
            }
            catch
            {
                return -1;
            }
        }

        public bool AddTable(int id, string name, string status)
        {
            int count = TableDAO.Instance.CheckExistTableName(name);

            if(count == 0)
            {
                string query = string.Format("INSERT INTO dbo.FoodTable(Name, status) VALUES (N'{0}', N'{1}')", name, status);
                int result = DataProvider.Instance.ExecuteNonQuery(query);
                return result > 0;
            }
            return false;
        }

        public bool EditTable(int id, string name)
        {
            int count = TableDAO.Instance.CheckExistTableName(name);

            if (count == 0)
            {
                string query = string.Format("UPDATE dbo.FoodTable SET Name = N'{0}' WHERE TableID = {1}", name, id);
                int result = DataProvider.Instance.ExecuteNonQuery(query);
                return result > 0;
            }
            return false;
        }

        public bool DeleteCategory(int id)
        {
            BillInfoDAO.Instance.DeleteBillInfoByTableID(id);
            BillDAO.Instance.DeleteBillByTableID(id);
            string query = string.Format("DELETE FROM dbo.FoodTable WHERE TableID = {0}", id);
            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }
    }
}
