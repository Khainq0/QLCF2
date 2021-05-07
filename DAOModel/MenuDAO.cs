using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Menu = PhanMemQLCafe.DTOModel.Menu;

namespace PhanMemQLCafe.DAOModel
{
    public class MenuDAO
    {
        private static MenuDAO instance;

        public static MenuDAO Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new MenuDAO();
                }
                return MenuDAO.instance;
            }
            private set
            {
                MenuDAO.instance = value;
            }
        }

        private MenuDAO() { }

        public List<Menu> GetListMenuByTable(int id)
        {
            List<Menu> listMenu = new List<Menu>();

            string query = "SELECT f.Name, bi.Count, f.Price, f.Price * bi.Count AS totalPrice FROM Food as f, BillInfo as bi, Bill as b WHERE bi.BillID = b.BillID AND bi.FoodID = f.FoodID AND b.Status = 0 AND b.TableID = "+id+" ";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Menu menu = new Menu(item);
                listMenu.Add(menu);
            }

            return listMenu;
        }
    }
}
