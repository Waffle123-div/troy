using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Configuration;
using global::MySql.Data.MySqlClient;

namespace Booking_system
{
    /// <summary>
    /// Database helper class that provides direct access to MySQL
    /// </summary>
    public static class DBHelper
    {
        // Use standard type names with proper imports
        private static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
        }

        public static MySqlConnection GetConnection()
        {
            return DirectMySqlAccess.GetConnection(GetConnectionString());
        }

        public static DataTable ExecuteQuery(string sqlQuery, params MySqlParameter[] parameters)
        {
            DataTable dt = new DataTable();
            using (MySqlConnection conn = GetConnection())
            {
                using (MySqlCommand cmd = new MySqlCommand(sqlQuery, conn))
                {
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    using (MySqlDataAdapter adapter = new MySqlDataAdapter(cmd))
                    {
                        conn.Open();
                        adapter.Fill(dt);
                    }
                }
            }
            return dt;
        }

        public static int ExecuteNonQuery(string sqlQuery, params MySqlParameter[] parameters)
        {
            int result = 0;
            using (MySqlConnection conn = GetConnection())
            {
                using (MySqlCommand cmd = new MySqlCommand(sqlQuery, conn))
                {
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    conn.Open();
                    result = cmd.ExecuteNonQuery();
                }
            }
            return result;
        }

        public static object ExecuteScalar(string sqlQuery, params MySqlParameter[] parameters)
        {
            object result = null;
            using (MySqlConnection conn = GetConnection())
            {
                using (MySqlCommand cmd = new MySqlCommand(sqlQuery, conn))
                {
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    conn.Open();
                    result = cmd.ExecuteScalar();
                }
            }
            return result;
        }

        // Helper method to create a MySqlParameter
        public static MySqlParameter CreateParameter(string name, object value)
        {
            return DirectMySqlAccess.CreateParameter(name, value);
        }
    }
} 