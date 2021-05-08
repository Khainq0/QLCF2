using PhanMemQLCafe.DTOModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PhanMemQLCafe.DAOModel
{
    public class BillDAO
    {
        private static BillDAO instance;

        public static BillDAO Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new BillDAO();
                }
                return instance;
            }

            private set
            {
                instance = value;
            }
        }

        private BillDAO() { }

        /// <summary>
        /// Thành công: bill ID
        /// thất bại: -1
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int GetUncheckBillIDByTableID(int id)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM Bill WHERE TableID = "+ id +" ");
            
            if (data.Rows.Count > 0)
            {
                Bill bill = new Bill(data.Rows[0]);
                return bill.ID;
            }
            return -1;
        }

        public int GetUncheckStatusByTableID(int id)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM Bill WHERE TableID = " + id + " ");

            if (data.Rows.Count > 0)
            {
                Bill bill = new Bill(data.Rows[0]);
                return bill.Status;
            }
            return -1;
        }

        public string GetTableStatusByTableID(int id)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM FoodTable WHERE TableID = " + id + " ");

            if (data.Rows.Count > 0)
            {
                Table table = new Table(data.Rows[0]);
                return table.Status;
            }
            return "";
        }

        public void CheckOut(int id, int discount, float totalPrice)
        {
            string query = "UPDATE dbo.Bill SET DateCheckOut = GETDATE(), Status = 1 , "+" Discount = "+discount+", TotalPrice = "+totalPrice+" WHERE BillID = " + id + "";
            DataProvider.Instance.ExecuteNonQuery(query);
        }

        public void InsertBill(int id)
        {
            DataProvider.Instance.ExecuteNonQuery("exec USP_InsertBill @TableID , member2", new object[] { id });
            
        }

        public int GetMaxBill()
        {
            try 
            {
                return (int)DataProvider.Instance.ExecuteScalar("SELECT MAX(BillID) FROM Bill");
            }
            catch
            {
                return -1;
            }
        }

        public int GetMaxBillOfTable(int id)
        {
            try
            {
                return (int)DataProvider.Instance.ExecuteScalar("SELECT MAX(BillID) FROM Bill WHERE TableID = "+id+"");
            }
            catch
            {
                return -1;
            }
        }

        public int CountSameBills(int id)
        {
            try
            {
                return (int)DataProvider.Instance.ExecuteScalar("SELECT COUNT(BillID) FROM Bill WHERE   TableID = "+id+"");
            }
            catch
            {
                return -1;
            }
        }

        public DataTable GetListBillByDate(DateTime checkIn, DateTime checkOut)
        {
            return DataProvider.Instance.ExecuteQuery("EXEC USP_GetListBillByDate @checkIn , @checkOut", new object[] { checkIn, checkOut});
        }

        public void DeleteBillByTableID(int id)
        {
            DataProvider.Instance.ExecuteQuery("DELETE FROM dbo.Bill WHERE TableID = " + id);
        }
    }
}
