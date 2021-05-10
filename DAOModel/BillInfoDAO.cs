using PhanMemQLCafe.DTOModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PhanMemQLCafe.DAOModel
{
    public class BillInfoDAO
    {
        private static BillInfoDAO instance;

        public static BillInfoDAO Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new BillInfoDAO();
                }
                return BillInfoDAO.instance;
            }
            private set
            {
                BillInfoDAO.instance = value;
            }
        }

        private BillInfoDAO() { }

        public List<BillInfo> GetListBillInfo(int id)
        {
            List<BillInfo> listBillInfo = new List<BillInfo>();

            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM dbo.BillInfo WHERE BillID = " + id + " ");

            foreach (DataRow item in data.Rows)
            {
                BillInfo info = new BillInfo(item);
                listBillInfo.Add(info);
            }

            return listBillInfo;
        }

        public void InsertBillInfo(int foodID, int billID, int count)
        {
            DataProvider.Instance.ExecuteNonQuery("exec USP_InsertBillInfo @FoodID , @BillID , @Count", new object[] { foodID , billID , count });
        }

        public void DeleteBillInfoByFoodID(int id)
        {
            DataProvider.Instance.ExecuteQuery("DELETE dbo.BillInfo WHERE FoodID = " + id);
        }

        public void DeleteBillInfoByTableID(int id)
        {
            DataProvider.Instance.ExecuteQuery("DELETE FROM dbo.BillInfo WHERE BillID = (SELECT BillID FROM dbo.Bill WHERE TableID = "+id+")");
        }

        public void DeleteBillInfoByCategoryID(int id)
        {
            DataProvider.Instance.ExecuteQuery("DELETE FROM dbo.BillInfo WHERE FoodID = (SELECT DISTINCT bi.FoodID FROM dbo.FoodCategory AS fc, dbo.BillInfo AS bi, dbo.Food AS f WHERE "+id+" = f.CategoryID AND f.FoodID = bi.FoodID)");
        }
    }
}
