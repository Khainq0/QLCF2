using PhanMemQLCafe.DTOModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PhanMemQLCafe.DAOModel
{
    public class CategoryDAO
    {
        private static CategoryDAO instance;

        public static CategoryDAO Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new CategoryDAO();
                }
                return instance;
            }

            private set
            {
                instance = value;
            }
        }

        private CategoryDAO() { }

        public List<Category> GetListCategory()
        {
            List<Category> list = new List<Category>();

            string query = "SELECT * FROM FoodCategory";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Category category = new Category(item);
                list.Add(category);
            }

            return list;
        }

        public Category GetCategoryNameByID(int id)
        {
            Category category = null;

            string query = "SELECT * FROM FoodCategory WHERE CategoryID = " + id;

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                category = new Category(item);
                return category;
            }

            return category;
        }

        public int GetCategoryIDByCategoryName(string name)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM FoodCategory WHERE Name = N'"+ name +"' ");

            if (data.Rows.Count > 0)
            {
                Category category = new Category(data.Rows[0]);
                return category.ID;
            }
            return -1;
        }

        public int CheckExistCategoryName(string name)
        {
            try
            {
                int id = CategoryDAO.Instance.GetCategoryIDByCategoryName(name);
                return (int)DataProvider.Instance.ExecuteScalar("SELECT COUNT(*) FROM dbo.FoodCategory WHERE CategoryID = " + id + "");
            }
            catch
            {
                return -1;
            }
        }

        public bool AddCategory(int id, string name)
        {
            int count = CategoryDAO.Instance.CheckExistCategoryName(name);

            if (count == 0)
            {
                string query = string.Format("INSERT INTO dbo.FoodCategory( Name ) VALUES (N'{0}')", name);
                int result = DataProvider.Instance.ExecuteNonQuery(query);
                return result > 0;
            }
            return false;
        }

        public bool EditCategory(int id, string name)
        {
            int count = CategoryDAO.Instance.CheckExistCategoryName(name);

            if (count == 0)
            {
                string query = string.Format("UPDATE dbo.FoodCategory SET Name = N'{0}' WHERE CategoryID = {1}", name, id);
                int result = DataProvider.Instance.ExecuteNonQuery(query);
                return result > 0;
            }
            return false;
        }

        public bool DeleteCategory(int id)
        {
            FoodDAO.Instance.DeleteFoodByCategoryID(id);
            string query = string.Format("DELETE FROM dbo.FoodCategory WHERE CategoryID = {0}", id);
            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }
    }
}
