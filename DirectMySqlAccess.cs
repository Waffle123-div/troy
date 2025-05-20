using System;
using System.Data;
// Directly reference the MySQL namespace with global prefix
using global::MySql.Data.MySqlClient;

namespace Booking_system
{
    /// <summary>
    /// Direct MySQL access with namespace imports
    /// </summary>
    public static class DirectMySqlAccess
    {
        /// <summary>
        /// Get a connection to the database
        /// </summary>
        public static MySqlConnection GetConnection(string connectionString)
        {
            return new MySqlConnection(connectionString);
        }
        
        /// <summary>
        /// Create a command
        /// </summary>
        public static MySqlCommand CreateCommand(string commandText, MySqlConnection connection)
        {
            return new MySqlCommand(commandText, connection);
        }
        
        /// <summary>
        /// Create a parameter
        /// </summary>
        public static MySqlParameter CreateParameter(string name, object value)
        {
            return new MySqlParameter(name, value);
        }
        
        /// <summary>
        /// Execute a query and return the results as a DataTable
        /// </summary>
        public static DataTable ExecuteQuery(string connectionString, string sql)
        {
            DataTable result = new DataTable();
            using (MySqlConnection conn = GetConnection(connectionString))
            {
                using (MySqlCommand cmd = CreateCommand(sql, conn))
                {
                    conn.Open();
                    using (MySqlDataAdapter adapter = new MySqlDataAdapter(cmd))
                    {
                        adapter.Fill(result);
                    }
                }
            }
            return result;
        }
    }
} 