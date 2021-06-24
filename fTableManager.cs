using PhanMemQLCafe.DAOModel;
using PhanMemQLCafe.DTOModel;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Globalization;
using Menu = PhanMemQLCafe.DTOModel.Menu;

namespace PhanMemQLCafe
{
    public partial class fTableManager : Form
    {
        private Account loginAccount;
        public Account LoginAccount
        {
            get { return loginAccount; }
            set { loginAccount = value; ChangeAccount(loginAccount.IsManager); }
        }

        public fTableManager(Account acc)
        {
            InitializeComponent();
            this.LoginAccount = acc;
            LoadTable();
            LoadCategory();
            LoadComboboxTable(cbSwitchTable);
            FormBorderStyle = FormBorderStyle.FixedSingle;
        }

        #region Method

        //đổi text hiển thị của menuStrip
        void ChangeAccountInfo(string info)
        {
            thôngTinTàiKhoảnToolStripMenuItem.Text = "Thông tin tài khoản (" + info + ")";
        }

        void ChangeAccount(bool isManager)
        {
            adminToolStripMenuItem.Enabled = isManager == true;
            thôngTinTàiKhoảnToolStripMenuItem.Text += " (" + LoginAccount.Name + ")";
        }

        void LoadCategory()
        {
            List<Category> listCategory = CategoryDAO.Instance.GetListCategory();
            cbCategory.DataSource = listCategory;
            cbCategory.ForeColor = Color.Blue;
            cbCategory.DisplayMember = "Name";
        }

        void LoadFoodListByCategoryID(int id)
        {
            List<Food> listFood = FoodDAO.Instance.GetFoodByCategoryID(id);
            cbFood.DataSource = listFood;
            cbFood.ForeColor = Color.Blue;
            cbFood.DisplayMember = "Name";
        }

        void LoadTable()
        {
            flpTable.Controls.Clear();

            List<Table> tableList = TableDAO.Instance.LoadTableList();

            foreach (Table item in tableList)
            {
                Button btn = new Button() 
                { 
                    Width = TableDAO.TableWidth,
                    Height = TableDAO.TableHeight
                };
                btn.Text = item.Name + Environment.NewLine;
                //btn.ForeColor = Color.Blue;
                btn.Font = new Font("French Script MT", 18);
                btn.ForeColor = Color.DarkBlue;

                btn.Click += btn_Clik;
                btn.Tag = item;

                switch (item.Status)
                {
                    case "Trống":
                        //btn.BackColor = Color.Aqua;
                        btn.Image = Image.FromFile("C:\\Users\\ADMIN\\Documents\\Study\\Hoc_Ki_6\\Thuc_Tap_Nhom\\MyProject\\QLCF\\Resources\\dinner-table.png");
                        break;
                    default:
                        //btn.BackColor = Color.IndianRed;
                        btn.Image = Image.FromFile("C:\\Users\\ADMIN\\Documents\\Study\\Hoc_Ki_6\\Thuc_Tap_Nhom\\MyProject\\QLCF\\Resources\\guest.png");
                        break;
                }

                flpTable.Controls.Add(btn);
            }
        }

        void ShowBill(int id)
        {
            lvBill.Items.Clear();

            List<Menu> menu = MenuDAO.Instance.GetListMenuByTable(id);

            float totalPrice = 0;

            foreach (Menu item in menu)
            {
                ListViewItem lsvItem = new ListViewItem(item.FoodName.ToString());
                lsvItem.SubItems.Add(item.Count.ToString());
                lsvItem.SubItems.Add(item.Price.ToString());
                lsvItem.SubItems.Add(item.TotalPrice.ToString());
                totalPrice += item.TotalPrice;

                lvBill.Items.Add(lsvItem);
            }
            CultureInfo culture = new CultureInfo("vi-VN");
            txbTotalPrice.Text = totalPrice.ToString("c", culture); 
        }

        void LoadComboboxTable(ComboBox cb)
        {
            cb.DataSource = TableDAO.Instance.LoadTableList();
            cb.DisplayMember = "Name";
            cb.ForeColor = Color.Green;
        }

        #endregion

        #region Events

        void btn_Clik(object sender, EventArgs e)
        {
            int tableID = ((sender as Button).Tag as Table).ID;
            lvBill.Tag = (sender as Button).Tag;

            ShowBill(tableID);
        }

        private void đăngXuấtToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void thôngTinCáNhânToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fAccountProfile f = new fAccountProfile(loginAccount);
            f.ChangeInfo = ChangeAccountInfo; //Trước khi show form fAccountProfile từ form chính, ta gán giá trị cho delegate ChangeInfo
            f.ShowDialog();
        }

        private void adminToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fAdmin f = new fAdmin();

            f.InsertFood += f_InsertFood;
            f.DeleteFood += f_DeleteFood;
            f.UpdateFood += f_UpdateFood;

            f.InsertCategory += f_InsertCategory;
            f.UpdateCategory += f_UpdateCategory;
            f.DeleteCategory += f_DeleteCategory;

            f.InsertTable += f_InsertTable;
            f.UpdateTable += f_UpdateTable;
            f.DeleteTable += f_DeleteTable;

            f.ShowDialog();
        }

        private void f_DeleteTable(object sender, EventArgs e)
        {
            LoadTable();
            //new
            LoadComboboxTable(cbSwitchTable);
        }

        private void f_UpdateTable(object sender, EventArgs e)
        {
            LoadTable();
            //new
            LoadComboboxTable(cbSwitchTable);
        }

        private void f_InsertTable(object sender, EventArgs e)
        {
            LoadTable();
            //new
            LoadComboboxTable(cbSwitchTable);
        }

        private void f_DeleteCategory(object sender, EventArgs e)
        {
            LoadCategory();
        }

        private void f_UpdateCategory(object sender, EventArgs e)
        {
            LoadCategory();
        }

        private void f_InsertCategory(object sender, EventArgs e)
        {
            LoadCategory();
        }

        private void f_UpdateFood(object sender, EventArgs e)
        {
            LoadFoodListByCategoryID((cbCategory.SelectedItem as Category).ID);
            if (lvBill.Tag != null)
                ShowBill((lvBill.Tag as Table).ID);
        }

        private void f_DeleteFood(object sender, EventArgs e)
        {
            LoadFoodListByCategoryID((cbCategory.SelectedItem as Category).ID);
            if (lvBill.Tag != null)
                ShowBill((lvBill.Tag as Table).ID);
            LoadTable();
        }

        private void f_InsertFood(object sender, EventArgs e)
        {
            LoadFoodListByCategoryID((cbCategory.SelectedItem as Category).ID);
            if (lvBill.Tag != null)
                ShowBill((lvBill.Tag as Table).ID);
        }

        private void cbCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            int id = 0;

            ComboBox cb = sender as ComboBox;

            if (cb.SelectedItem == null)
            {
                return;
            }

            Category selected = cb.SelectedItem as Category;
            id = selected.ID;
            LoadFoodListByCategoryID(id);
        }
        
        private void btnAddFood_Click(object sender, EventArgs e)
        {
            
            Table table = lvBill.Tag as Table;
            if (table != null)
            {
                int billID = BillDAO.Instance.GetUncheckBillIDByTableID(table.ID);

                int billStatus = BillDAO.Instance.GetUncheckStatusByTableID(table.ID);
                string tableStatus = (string)BillDAO.Instance.GetTableStatusByTableID(table.ID);

                int foodID = (cbFood.SelectedItem as Food).ID;

                int count = (int)nmFoodCount.Value;
                if(count <= 0)
                {
                    count = 1;
                }    

                if (billID == -1)
                {
                    BillDAO.Instance.InsertBill(table.ID);
                    BillInfoDAO.Instance.InsertBillInfo(foodID, BillDAO.Instance.GetMaxBill(), count);
                }
                else if (billStatus == 0 && tableStatus == "Trống")
                {
                    BillInfoDAO.Instance.InsertBillInfo(foodID, billID, count);
                }
                else if (billStatus == 0 && tableStatus == "Đã có người")
                {
                    BillInfoDAO.Instance.InsertBillInfo(foodID, billID, count);
                }
                else if (billStatus == 1 && tableStatus == "Trống")
                {
                    BillDAO.Instance.InsertBill(table.ID);
                    BillInfoDAO.Instance.InsertBillInfo(foodID, BillDAO.Instance.GetMaxBill(), count);
                }
                else if (billStatus == 1 && tableStatus == "Đã có người")
                {
                    BillInfoDAO.Instance.InsertBillInfo(foodID, BillDAO.Instance.GetMaxBill(), count);
                }

                ShowBill(table.ID);

                LoadTable();
            }
            else
            {
                MessageBox.Show("Bạn phải chọn bàn trước khi đặt món?");
            }
        }
        

        private void btnCheckOut_Click(object sender, EventArgs e)
        {
            Table table = lvBill.Tag as Table;

            if (table != null)
            {
                int billID = BillDAO.Instance.GetUncheckBillIDByTableID(table.ID);
                int discount = (int)nmDisCount.Value;
                double totalPrice = Convert.ToDouble(txbTotalPrice.Text.Split(',')[0]);
                double finalTotalPrice = 1000 * (totalPrice - (totalPrice / 100) * discount);

                if (BillDAO.Instance.CountSameBills(table.ID) > 0)
                {
                    billID = BillDAO.Instance.GetMaxBillOfTable(table.ID);
                }

                string tableStatus = (string)BillDAO.Instance.GetTableStatusByTableID(table.ID);

                if (billID != -1 && tableStatus == "Đã có người")
                {
                    if (MessageBox.Show(string.Format("Bạn có chắc chắn muốn thanh toán hóa đơn cho {0}?\nGiảm giá: {1}%\nThành tiền: {2}đ", table.Name, discount, finalTotalPrice), "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                    {
                        BillDAO.Instance.CheckOut(billID, discount, (float)finalTotalPrice);
                        ShowBill(table.ID);

                        LoadTable();
                    }
                }
            }
            else
            {
                MessageBox.Show("Chọn bàn trước khi thanh toán");
            }
        }

        private void btnSwitchTable_Click(object sender, EventArgs e)
        {
            try
            {
                int tableiD1 = (lvBill.Tag as Table).ID;

                int tableID2 = (cbSwitchTable.SelectedItem as Table).ID;

                if (MessageBox.Show(String.Format("Bạn muốn chuyển bàn {0} qua bàn {1}?", (lvBill.Tag as Table).Name, (cbSwitchTable.SelectedItem as Table).Name), "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                {
                    TableDAO.Instance.SwitchTable(tableiD1, tableID2);

                    LoadTable();
                }
            }
            catch
            {
                MessageBox.Show("Chưa chọn bàn để chuyển?");
            }
        }

        #endregion

        #region tenmp

        private void flpTable_Paint(object sender, PaintEventArgs e)
        {

        }

        private void cbSwitchTable_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void nmFoodCount_ValueChanged(object sender, EventArgs e)
        {

        }

        private void lvBill_SelectedIndexChanged(object sender, EventArgs e)
        {
            //
        }

        #endregion
    }
}
