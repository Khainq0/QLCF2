using PhanMemQLCafe.DTOModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PhanMemQLCafe.DAOModel
{
    public class FoodDAO
    {
        private static FoodDAO instance;

        public static FoodDAO Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new FoodDAO();
                }
                return instance;
            }

            private set
            {
                instance = value;
            }
        }

        private FoodDAO() { }

        public List<Food> GetFoodByCategoryID(int id)
        {
            List<Food> list = new List<Food>();

            string query = "SELECT * FROM Food WHERE CategoryID = "+id+"";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Food food = new Food(item);

                list.Add(food);
            }

            return list;
        }

        public List<Food> GetListFood()
        {
            List<Food> list = new List<Food>();

            string query = "SELECT FoodID, Name, CategoryID, Price FROM dbo.Food";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Food food = new Food(item);

                list.Add(food);
            }

            return list;
        }

        public int GetFoodIDByFoodName(string name)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM Food WHERE Name = N'"+name+"' ");

            if (data.Rows.Count > 0)
            {
                Food food = new Food(data.Rows[0]);
                return food.ID;
            }
            return -1;
        }

        public int CheckExistFoodName(string name)
        {
            try
            {
                int id = FoodDAO.Instance.GetFoodIDByFoodName(name);
                return (int)DataProvider.Instance.ExecuteScalar("SELECT COUNT(*) FROM dbo.Food WHERE FoodID = " + id + "");
            }
            catch
            {
                return -1;
            }
        }

        public bool AddFood(string name, int categoryID, float price)
        {
            int count = FoodDAO.Instance.CheckExistFoodName(name);

            if (count == 0)
            {
                string query = string.Format("INSERT dbo.Food(Name, CategoryID, Price, UserName) VALUES(N'{0}', {1}, {2}, 'member0')", name, categoryID, price);
                int result = DataProvider.Instance.ExecuteNonQuery(query);
                return result > 0;
            }
            return false;
        }

        public bool EditFood(int foodID, string name, int categoryID, float price)
        {
            string query = string.Format("UPDATE dbo.Food SET name = N'{0}', CategoryID = {1}, Price = {2} WHERE FoodID = {3}", name, categoryID, price, foodID);
            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool DeleteFood(int foodID)
        {
            BillInfoDAO.Instance.DeleteBillInfoByFoodID(foodID);

            string query = string.Format("DELETE dbo.Food WHERE FoodID = {0}", foodID);
            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public List<Food> SearchFoodByName(string name)
        {
            List<Food> list = new List<Food>();

            //string query = "SELECT * FROM dbo.Food WHERE name like N'%"+name+"%'";
            string query = string.Format("SELECT * FROM dbo.Food WHERE dbo.TimkiemGanDung(name) LIKE N'%' + dbo.TimkiemGanDung(N'{0}') + '%'", name);
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Food food = new Food(item);

                list.Add(food);
            }

            return list;
        }

        public List<Category> GetListCategory()
        {
            List<Category> list = new List<Category>();

            string query = "SELECT * FROM dbo.FoodCategory ORDER BY CategoryID";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Category category = new Category(item);

                list.Add(category);
            }

            return list;
        }

        public void DeleteFoodByCategoryID(int id)
        {
            DataProvider.Instance.ExecuteQuery("DELETE FROM dbo.Food WHERE CategoryID = " +id);
        }
    }
}
