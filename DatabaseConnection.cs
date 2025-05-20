using System;
using System.Data;
using System.Configuration;
using global::MySql.Data.MySqlClient;

namespace Booking_system
{
    /// <summary>
    /// Database connection helper class for MySQL
    /// </summary>
    public class DatabaseConnection
    {
        private static string ConnectionString = ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;

        public static MySqlConnection GetConnection()
        {
            return new MySqlConnection(ConnectionString);
        }

        public static DataTable ExecuteQuery(string sql, params MySqlParameter[] parameters)
        {
            DataTable dt = new DataTable();
            
            using (MySqlConnection conn = GetConnection())
            {
                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    
                    MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                    conn.Open();
                    adapter.Fill(dt);
                }
            }
            
            return dt;
        }

        public static int ExecuteNonQuery(string sql, params MySqlParameter[] parameters)
        {
            int result = 0;
            
            using (MySqlConnection conn = GetConnection())
            {
                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    
                    conn.Open();
                    result = cmd.ExecuteNonQuery();
                }
            }
            
            return result;
        }

        public static object ExecuteScalar(string sql, params MySqlParameter[] parameters)
        {
            object result = null;
            
            using (MySqlConnection conn = GetConnection())
            {
                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    
                    conn.Open();
                    result = cmd.ExecuteScalar();
                }
            }
            
            return result;
        }
    }
} 