using System;
using System.Data;
using System.Configuration;
using global::MySql.Data.MySqlClient;

namespace Booking_system
{
    /// <summary>
    /// Provides standardized database access that can be switched between MySQL and SQL Server
    /// </summary>
    public static class DatabaseProvider
    {
        public static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["EventBookingDBConnection"].ConnectionString;
        }

        // Factory methods
        public static IDbConnection CreateConnection()
        {
            // Create MySQL connection
            return new MySqlConnection(GetConnectionString());
        }

        public static IDbCommand CreateCommand(string commandText, IDbConnection connection)
        {
            var cmd = connection.CreateCommand();
            cmd.CommandText = commandText;
            return cmd;
        }

        public static IDbDataParameter CreateParameter(string paramName, object value)
        {
            var param = new MySqlParameter(paramName, value);
            return param;
        }

        public static IDbDataAdapter CreateDataAdapter(IDbCommand command)
        {
            return new MySqlDataAdapter((MySqlCommand)command);
        }
    }
} 
