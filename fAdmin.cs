using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using PhanMemQLCafe.DAOModel;
using PhanMemQLCafe.DTOModel;

namespace PhanMemQLCafe
{
    public partial class fAdmin : Form
    {
        BindingSource foodList = new BindingSource();
        BindingSource categoryList = new BindingSource();
        BindingSource tableList = new BindingSource();
        BindingSource accountList = new BindingSource();
        public fAdmin()
        {
            InitializeComponent();

            //bill
            LoadDateTimePickerBill();
            LoadListBillByDate(dtpkFromDate.Value, dtpkToday.Value);

            //food
            dtgvFood.DataSource = foodList;
            LoadListFood();
            LoadCategoryIntoCombobox(cbFoodCategory);
            AddFoodBinding();

            //category
            dtgvCategory.DataSource = categoryList;
            LoadListCategory();
            AddCategoryBinding();

            //table
            dtgvTable.DataSource = tableList;
            LoadListTable();
            AddTableBinding();
            LoadTableStatusIntoCombobox(cbTableStatus);

            //account
            dtgvAccount.DataSource = accountList;
            LoadListAccount();
            AddAccountBinding();
            FormBorderStyle = FormBorderStyle.FixedSingle;
        }

        private void label8_Click(object sender, EventArgs e)
        {
            //null
        }

        #region methods

        List<Food> SearchFoodByName(string name)
        {
            List<Food> listFood = FoodDAO.Instance.SearchFoodByName(name);


            return listFood;
        }

        void LoadCategoryIntoCombobox(ComboBox cb)
        {
            cb.DataSource = CategoryDAO.Instance.GetListCategory();
            cb.DisplayMember = "Name";
        }

        void LoadTableStatusIntoCombobox(ComboBox cb)
        {
            cbTableStatus.DataSource = TableDAO.Instance.GetListTable();
            cb.DisplayMember = "Status";
        }

        void AddAccountBinding()
        {
            txbUserName.DataBindings.Add(new Binding("Text", dtgvAccount.DataSource, "UserName", true, DataSourceUpdateMode.Never));
            txbDisplayName.DataBindings.Add(new Binding("Text", dtgvAccount.DataSource, "Name", true, DataSourceUpdateMode.Never));
            nmAccountType.DataBindings.Add(new Binding("Value", dtgvAccount.DataSource, "isManager", true, DataSourceUpdateMode.Never));
        }

        void AddTableBinding()
        {
            txbTableID.DataBindings.Add(new Binding("Text", dtgvTable.DataSource, "ID", true, DataSourceUpdateMode.Never));
            txbTableName.DataBindings.Add(new Binding("Text", dtgvTable.DataSource, "Name", true, DataSourceUpdateMode.Never));
        }

        void AddCategoryBinding()
        {
            txbCategoryID.DataBindings.Add(new Binding("Text", dtgvCategory.DataSource, "ID", true, DataSourceUpdateMode.Never));
            txbCategoryName.DataBindings.Add(new Binding("Text", dtgvCategory.DataSource, "Name", true, DataSourceUpdateMode.Never));
        }

        void AddFoodBinding()
        {
            txbFoodName.DataBindings.Add(new Binding("Text", dtgvFood.DataSource, "Name", true, DataSourceUpdateMode.Never));
            txbFoodID.DataBindings.Add(new Binding("Text", dtgvFood.DataSource, "ID", true, DataSourceUpdateMode.Never));
            nmFoodPrice.DataBindings.Add(new Binding("value", dtgvFood.DataSource, "Price", true, DataSourceUpdateMode.Never));
        }

        void LoadDateTimePickerBill()
        {
            DateTime today = DateTime.Now;
            dtpkFromDate.Value = new DateTime(today.Year, today.Month, 1);
            dtpkToday.Value = dtpkFromDate.Value.AddMonths(1).AddDays(-1);
        }

        void LoadListBillByDate(DateTime checkIn, DateTime checkOut)
        {
            dtgvBill.DataSource = BillDAO.Instance.GetListBillByDate(checkIn, checkOut);
        }

        void LoadListFood()
        {
            foodList.DataSource = FoodDAO.Instance.GetListFood();
        }

        void LoadListCategory()
        {
            categoryList.DataSource = FoodDAO.Instance.GetListCategory();
        }

        void LoadListTable()
        {
            tableList.DataSource = TableDAO.Instance.GetListTable();
        }

        void LoadListAccount()
        {
            accountList.DataSource = AccountDAO.Instance.GetListAccount();
        }

        void InsertAccount(string userName, string name, int type)
        {
            if (AccountDAO.Instance.AddAccount(userName, name, type))
            {
                MessageBox.Show("Thêm tài khoản thành công!");
                LoadListAccount();
            }
            else
            {
                MessageBox.Show("Tài khoản đã tài tại.\nThêm tài khoản không thành công!");
            }        
        }
        void UpdateAccount(string userName, string name, int type)
        {
            if (AccountDAO.Instance.EditAccount(userName, name, type))
            {
                MessageBox.Show("Cập nhật tài khoản thành công!");
                LoadListAccount();
            }
            else
            {
                MessageBox.Show("Tài khoản đã tồn tại.\nCập nhật tài khoản không thành công!");
            }    
        }

        void deleteAccount(string userName)
        {
            if (MessageBox.Show("Bạn có muốn xóa tài khoản không?", "Thông báo!", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
            {
                if (AccountDAO.Instance.DeleteAccount(userName))
                {
                    LoadListAccount();
                    MessageBox.Show("Xóa tài khoản thành công!");
                }
            }
            else
            {
                MessageBox.Show("Xóa tài khoản không thành công!");
            }
        }

        void ResetPass(string userName)
        {
            if (MessageBox.Show("Bạn có cập nhật lại mật khẩu không?", "Thông báo!", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
            {
                if (AccountDAO.Instance.ResetPassword(userName))
                {
                    MessageBox.Show("Đặt lại mật khẩu thành công!");
                }
            }              
            else
            {
                MessageBox.Show("Đặt lại mật khẩu không thành công!");
            }
            LoadListAccount();
        }

        #endregion

        #region events

        private void btnShowCategory_Click(object sender, EventArgs e)
        {
            LoadListCategory();
        }

        private void btnSearchFood_Click(object sender, EventArgs e)
        {
            foodList.DataSource = SearchFoodByName(txbSearchFoodName.Text);
        }

        private void btnViewBill_Click(object sender, EventArgs e)
        {
            LoadListBillByDate(dtpkFromDate.Value, dtpkToday.Value);
        }

        private void btnShowFood_Click(object sender, EventArgs e)
        {
            LoadListFood();
        }

        private void dtgvFood_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            //
        }

        private void txbFoodID_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (dtgvFood.SelectedCells.Count > 0)
                {
                    int id = (int)dtgvFood.SelectedCells[0].OwningRow.Cells["CategoryID"].Value;

                    Category cateogory = CategoryDAO.Instance.GetCategoryNameByID(id);

                    cbFoodCategory.SelectedItem = cateogory;

                    int index = -1;
                    int i = 0;
                    foreach (Category item in cbFoodCategory.Items)
                    {
                        if (item.ID == cateogory.ID)
                        {
                            index = i;
                            break;
                        }
                        i++;
                    }
                    cbFoodCategory.SelectedIndex = index;
                }
            }
            catch { }
        }


        //Quản lí đồ uống
        private void btnAddFood_Click(object sender, EventArgs e)
        {
            string name = txbFoodName.Text;
            int categoryID = (cbFoodCategory.SelectedItem as Category).ID;
            float price = (float)nmFoodPrice.Value;

            if (FoodDAO.Instance.AddFood(name, categoryID, price))
            {
                MessageBox.Show("Thêm món thành công!");
                LoadListFood();
                if (insertFood != null)
                    insertFood(this, new EventArgs());
            }
            else
            {
                MessageBox.Show("Món đã tồn tại.\nThêm không thành công!");
            }
        }

        private void btnEditFood_Click(object sender, EventArgs e)
        {
            string name = txbFoodName.Text;
            int categoryID = (cbFoodCategory.SelectedItem as Category).ID;
            float price = (float)nmFoodPrice.Value;
            int foodID = Convert.ToInt32(txbFoodID.Text);

            try
            {
                if (MessageBox.Show("Bạn có muốn sửa danh mục không?", "Thông báo!", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                {
                    if (FoodDAO.Instance.EditFood(foodID, name, categoryID, price))
                    {
                        MessageBox.Show("Sửa món thành công!");
                        LoadListFood();
                        //LoadFoodListByCategoryID(categoryID);
                        if (updateFood != null)
                            updateFood(this, new EventArgs());
                    }
                }
            }
            catch
            {
                MessageBox.Show("Món đã tồn tại.\nSửa món không thành công!");
            }
        }

        private void btnDeleteFood_Click(object sender, EventArgs e)
        {
            int foodID = Convert.ToInt32(txbFoodID.Text);

            if (MessageBox.Show("Bạn có muốn xóa món ăn không?", "Thông báo!", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
            {
                if (FoodDAO.Instance.DeleteFood(foodID))
                {
                    MessageBox.Show("Xóa món thành công!");
                    LoadListFood();
                    if (deleteFood != null)
                        deleteFood(this, new EventArgs());
                }
            }
            else
            {
                MessageBox.Show("Xóa món không thành công!");
            }
        }

        //new: thay doi khi insert, update, delete du lieu tren lvBill cung thay doi
        private event EventHandler insertFood;
        public event EventHandler InsertFood
        {
            add { insertFood += value; }
            remove { insertFood -= value; }
        }

        private event EventHandler deleteFood;
        public event EventHandler DeleteFood
        {
            add { deleteFood += value; }
            remove { deleteFood -= value; }
        }

        private event EventHandler updateFood;
        public event EventHandler UpdateFood
        {
            add { updateFood += value; }
            remove { updateFood -= value; }
        }


        //Quản lí danh mục
        private void btnAddCategory_Click(object sender, EventArgs e)
        {
            string name = txbCategoryName.Text;
            int categoryID = Convert.ToInt32(txbCategoryID.Text);

            if (CategoryDAO.Instance.AddCategory(categoryID, name))
            {
                MessageBox.Show("Thêm danh mục thành công!");
                LoadCategoryIntoCombobox(cbFoodCategory);
                LoadListCategory();
                LoadCategoryIntoCombobox(cbFoodCategory);
                if (insertCategory != null)
                    insertCategory(this, new EventArgs());
            }

            else
            {
                MessageBox.Show("Thêm không thành công.\nDanh mục đã tồn tại!");
            }
        }

        private void btnEditCategory_Click(object sender, EventArgs e)
        {
            string name = txbCategoryName.Text;
            int categoryID = Convert.ToInt32(txbCategoryID.Text);

            try
            {
                if (MessageBox.Show("Bạn có muốn sửa danh mục không?", "Thông báo!", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                {
                    if (CategoryDAO.Instance.EditCategory(categoryID, name))
                    {
                        MessageBox.Show("Sửa danh mục thành công!");
                        LoadCategoryIntoCombobox(cbFoodCategory);
                        LoadListCategory();
                        LoadCategoryIntoCombobox(cbFoodCategory);
                        if (updateCategory != null)
                            updateCategory(this, new EventArgs());
                    }
                }
            }
            catch
            {
                MessageBox.Show("Danh mục đã tồn tại.\nSửa danh mục không thành công!");
            }
        }

        private void btnDeleteCategory_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(txbCategoryID.Text);

            if (MessageBox.Show("Bạn có muốn xóa danh mục không?", "Thông báo!", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
            {
                if (CategoryDAO.Instance.DeleteCategory(id))
                {
                    MessageBox.Show("Xóa danh mục thành công!");
                    LoadListCategory();
                    LoadCategoryIntoCombobox(cbFoodCategory);
                    LoadListFood();
                    if (deleteCategory != null)
                        deleteCategory(this, new EventArgs());
                }
                else
                {
                    MessageBox.Show("Xóa danh mục không thành công!");
                }
            }
        }

        private event EventHandler insertCategory;
        public event EventHandler InsertCategory
        {
            add { insertCategory += value; }
            remove { insertCategory -= value; }
        }

        private event EventHandler updateCategory;
        public event EventHandler UpdateCategory
        {
            add { updateCategory += value; }
            remove { updateCategory -= value; }
        }

        private event EventHandler deleteCategory;
        public event EventHandler DeleteCategory
        {
            add { deleteCategory += value; }
            remove { deleteCategory -= value; }
        }


        //Quản lí bàn
        private void btnAddTable_Click(object sender, EventArgs e)
        {
            string name = txbTableName.Text;
            int id = Convert.ToInt32(txbTableID.Text);
            string status = cbTableStatus.Text;

            if (TableDAO.Instance.AddTable(id, name, status))
            {
                MessageBox.Show("Thêm bàn thành công!");
                LoadListTable();
                if (insertTable != null)
                    insertTable(this, new EventArgs());
            }
            else
            {
                MessageBox.Show("Thêm bàn không thành công.\nBàn đã tồn tại!");
            }    
        }

        private void btnEditTable_Click(object sender, EventArgs e)
        {
            string name = txbTableName.Text;
            int id = Convert.ToInt32(txbTableID.Text);

            try
            {
                if (MessageBox.Show("Bạn có muốn cập nhật bàn không?", "Thông báo!", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                {
                    if (TableDAO.Instance.EditTable(id, name))
                    {
                        MessageBox.Show("Cập nhật bàn thành công thành công!");
                        LoadListTable();
                        if (updateTable != null)
                            updateTable(this, new EventArgs());
                    }
                }
            }
            catch
            {
                MessageBox.Show("Bàn đã tồn tại.\nCập nhật bàn không thành công!");
            }
        }

        private void btnDeleteTable_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(txbTableID.Text);

            if (MessageBox.Show("Bạn có muốn xóa bàn không?", "Thông báo!", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
            {
                if (TableDAO.Instance.DeleteCategory(id))
                {
                    LoadListTable();
                    LoadListBillByDate(dtpkFromDate.Value, dtpkToday.Value);
                    if (deleteTable != null)
                        deleteTable(this, new EventArgs());
                    MessageBox.Show("Xóa bàn thành công!");
                }
                else
                {
                    MessageBox.Show("Xóa danh mục không thành công!");
                }
            }
        }

        private event EventHandler insertTable;
        public event EventHandler InsertTable
        {
            add { insertTable += value; }
            remove { insertTable -= value; }
        }

        private event EventHandler updateTable;
        public event EventHandler UpdateTable
        {
            add { updateTable += value; }
            remove { updateTable -= value; }
        }

        private event EventHandler deleteTable;
        public event EventHandler DeleteTable
        {
            add { deleteTable += value; }
            remove { deleteTable -= value; }
        }


        //Quản lí tài khoản
        private void btnAddAccount_Click(object sender, EventArgs e)
        {
            string userName = txbUserName.Text;
            string name = txbDisplayName.Text;
            int type = (int)nmAccountType.Value;

            InsertAccount(userName, name, type);
        }

        private void btnEditAccount_Click(object sender, EventArgs e)
        {
            string userName = txbUserName.Text;
            string name = txbDisplayName.Text;
            int type = (int)nmAccountType.Value;

            UpdateAccount(userName, name, type);
        }

        private void button4_Click(object sender, EventArgs e)
        {
            string userName = txbUserName.Text;
            deleteAccount(userName);
        }

        private void btnResetPassword_Click(object sender, EventArgs e)
        {
            string userName = txbUserName.Text;
            ResetPass(userName);
        }

        private void btnShowAccount_Click(object sender, EventArgs e)
        {
            //null
        }
        #endregion

    }
}
