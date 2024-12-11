using System.Data.SqlClient;
using System.Linq;
using Dapper;

namespace ProductLibrary
{
    public class ProductsProvider
    {
        private const string CONN_STRING = "Server=host.docker.internal;Database=product-db;User Id=sa;Password=Test@123;";
        private const string QUERY = "SELECT Id, Name, Description FROM product";
        
        public Product[] GetAll()
        {
            using (var connection = new SqlConnection(CONN_STRING))
            {
                return connection.Query<Product>(QUERY).ToArray();
            }
        }
        public Product[] Search(string query)
        {
            using (var connection = new SqlConnection(CONN_STRING))
            {
                return connection.Query<Product>($"{QUERY} WHERE Name LIKE '%{query}%' OR Description LIKE '%{query}%'").ToArray();
            }
        }
    }
}
