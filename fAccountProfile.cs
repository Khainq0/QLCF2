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

namespace PhanMemQLCafe
{
    public partial class fAccountProfile : Form
    {
        private Account loginAccount;
        public Account LoginAccount
        {
            get { return loginAccount; }
            set { loginAccount = value; ChangeAccount(LoginAccount); }
        }

        //Vì ở form con, không thể gọi trực tiếp hàm đã tạo ở form chính, nên phải gọi thông qua delegate. Ta tạo một thể hiện của delegate Action<string>.
        public Action<string> ChangeInfo;

        public fAccountProfile(Account acc)
        {
            InitializeComponent();
            LoginAccount = acc;
        }

        void ChangeAccount(Account acc)
        {
            txbUserName.Text = LoginAccount.UserName;
            txbDisplayName.Text = LoginAccount.Name;
            //txbPassword.Text = LoginAccount.Password;         
        }

        void UpdateAccount()
        {
            string name = txbDisplayName.Text;
            string password = txbPassword.Text;
            string newPassword = txbNewPassword.Text;
            string reEnterPassword = txbReEnterPassword.Text;
            string userName = txbUserName.Text;

            if (!newPassword.Equals(reEnterPassword))
            {
                MessageBox.Show("Mật khẩu mới không trùng khớp!");
            }
            else
            {
                if (AccountDAO.Instance.UpdateAccount(userName, name, password, newPassword))
                {
                    MessageBox.Show("Cập nhật thành công!");
                    ChangeInfo.Invoke(name); //Thực thi delegate, để gọi hàm đã tạo ở form fTableManager
                }
                else
                {
                    MessageBox.Show("Tài khoản hoặc mật khẩu không đúng!");
                }    
            }
            txbPassword.Text = "";
            txbReEnterPassword.Text = "";
            txbNewPassword.Text = "";
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            UpdateAccount();
        }

        private void txbUserName_TextChanged(object sender, EventArgs e)
        {

        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
