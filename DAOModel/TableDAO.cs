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
    }
}
