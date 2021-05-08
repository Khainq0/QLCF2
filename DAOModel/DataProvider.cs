using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PhanMemQLCafe.DAOModel
{
    public class DataProvider
    {
        private static DataProvider instance;
        public static DataProvider Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new DataProvider();
                }
                return DataProvider.instance;
            }
            private set
            {
                DataProvider.instance = (DataProvider)value;
            }
        }

        private DataProvider() { }  

        private string connectionStr = "Data Source=ANHHIEU\\SQLEXPRESS;Initial Catalog=Quanliquancafe;Integrated Security=True"; //Đường truyền SQL server

        public DataTable ExecuteQuery(string query, object[] parameter = null)
        {
            //**********Cách tránh nhập nhằng dữ liệu:
            DataTable data = new DataTable();
            //Dữ liệu khai báo trong using sẽ tự được giải phóng!!!! Ko bị dư thừa
            using (SqlConnection connection = new SqlConnection(connectionStr)) //Tạo kết nối
            {
                connection.Open();

                SqlCommand command = new SqlCommand(query, connection);

                if (parameter != null)
                {
                    string[] listPara = query.Split(' ');
                    int i = 0;
                    foreach (string item in listPara)
                    {
                        if (item.Contains('@'))
                        {
                            command.Parameters.AddWithValue(item, parameter[i]);
                            i++;
                        }
                    }
                }

                SqlDataAdapter adapter = new SqlDataAdapter(command);

                adapter.Fill(data);

                connection.Close();

                return data;
            }
        }

        //Kiểm tra số dòng excute thành công trong câu lệnh query
        public int ExecuteNonQuery(string query, object[] parameter = null)
        {
            //**********Cách tránh nhập nhằng dữ liệu:
            int data = 0;
            //Dữ liệu khai báo trong using sẽ tự được giải phóng!!!! Ko bị dư thừa
            using (SqlConnection connection = new SqlConnection(connectionStr)) //Tạo kết nối
            {
                connection.Open();

                SqlCommand command = new SqlCommand(query, connection);

                if (parameter != null)
                {
                    string[] listPara = query.Split(' ');
                    int i = 0;
                    foreach (string item in listPara)
                    {
                        if (item.Contains('@'))
                        {
                            command.Parameters.AddWithValue(item, parameter[i]);
                            i++;
                        }
                    }
                }

                data = command.ExecuteNonQuery();

                connection.Close();
            }
            return data;
        }

        //Đếm - phù hợp khi dùng Count(*)
        public object ExecuteScalar(string query, object[] parameter = null)
        {
            //**********Cách tránh nhập nhằng dữ liệu:
            int data = 0;
            //Dữ liệu khai báo trong using sẽ tự được giải phóng!!!! Ko bị dư thừa
            using (SqlConnection connection = new SqlConnection(connectionStr)) //Tạo kết nối
            {
                connection.Open();

                SqlCommand command = new SqlCommand(query, connection);

                if (parameter != null)
                {
                    string[] listPara = query.Split(' ');
                    int i = 0;
                    foreach (string item in listPara)
                    {
                        if (item.Contains('@'))
                        {
                            command.Parameters.AddWithValue(item, parameter[i]);
                            i++;
                        }
                    }
                }

                data = (int)command.ExecuteScalar();

                connection.Close();

                return data;
            }

        }

        internal void ExecuteNonQuery()
        {
            throw new NotImplementedException();
        }
    }
}
