using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace OSLab2
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            var connection = new SqlConnection("Data Source=(local);Integrated Security=SSPI;");
            var StartTime = DateTime.Now;
            connection.Open();
            var command = new SqlCommand("USE LR2; DELETE FROM Rent; DELETE FROM Client", connection);
            command.ExecuteNonQuery();
            TimeSpan diff = DateTime.Now - StartTime;
            TimeLabel.Content = $"completed in {diff.TotalSeconds} seconds";
            var getCount = new SqlCommand("USE LR2; SELECT COUNT(*) FROM Client", connection);
            int CountRows = Convert.ToInt32(getCount.ExecuteScalar());
            CountLabel.Content = CountRows.ToString() + " rows";
            connection.Close();
            InfoBox.Items.Clear();
        }

        public static readonly string[] firstNames = { "Dmytro", "Ivan", "Ilya", "Anastasia", "Sasha", "Svetlana", "Alina", "Julia", "Anna", "Stanislav"};
        public static readonly string[] secondNames = { "Bulatov", "Volkov", "Voitenko", "Starchenko", "Yadelskiy", "Reutska", "Melnikova", "Gamova", "Khuda", "Snitsarenko" };
        public static readonly string[] middleNames = { "Dmytrovich", "Ivanov", "Illich", "Stanislavovich", "Aleksandrovich", "Konstantinovich", "Vadimovich", "Egorovich", "Valeriovich", "Vadimovich" };

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            var connection = new SqlConnection("Data Source=(local);Integrated Security=SSPI;");
            connection.Open();
            var StartTime = DateTime.Now;
            int C1 = Convert.ToInt32(NumInput.Text);
            int Count = C1 < 1000 ? C1 : 1000;
            var getLastID = new SqlCommand("USE LR2; SELECT TOP(1) ID FROM Client ORDER BY ID DESC", connection);
            int ID = Convert.ToInt32(getLastID.ExecuteScalar()) + 1;
            while (C1 > 0)
            {
                C1 -= Count;
                string sqlQuery = "USE LR2; INSERT INTO Client(ID,FirstName,LastName,MiddleName) VALUES ";
                string sqlQuery2 = "USE LR2; INSERT INTO Rent(ID,ClientID) VALUES ";
                var r = new Random();
                for (; Count > 0; Count--, ID++)
                {
                    sqlQuery +=
                        $"({ID},'{firstNames[r.Next() % 10]}','{secondNames[r.Next() % 10]}','{middleNames[r.Next() % 10]}')";
                    if (Count != 1) sqlQuery += ",";
                    sqlQuery2 +=
                        $"({ID},{ID})";
                    if (Count != 1) sqlQuery2 += ",";
                }
                var command = new SqlCommand(sqlQuery, connection);
                command.ExecuteNonQuery();
                var command2 = new SqlCommand(sqlQuery2, connection);
                command2.ExecuteNonQuery();
                Count = C1 < 1000 ? C1 : 1000;
            }
            var select = new SqlCommand("USE LR2; SELECT TOP(1000) ID,FirstName,LastName,MiddleName FROM Client ORDER BY Client.ID DESC", connection);
            var reader = select.ExecuteReader();
            InfoBox.Items.Clear();
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    InfoBox.Items.Add(reader.GetString(1) + " " + reader.GetString(2) + " " + reader.GetString(3));
                }
            }
            reader.Close();
            TimeSpan diff = DateTime.Now - StartTime;
            TimeLabel.Content = $"completed in {diff.TotalSeconds} seconds";
            var getCount = new SqlCommand("USE LR2; SELECT COUNT(*) FROM Client", connection);
            int CountRows = Convert.ToInt32(getCount.ExecuteScalar());
            CountLabel.Content = CountRows.ToString() + " rows";
            connection.Close();
        }

        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void ListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void Grid_Initialized(object sender, EventArgs e)
        {
            var connection = new SqlConnection("Data Source=(local);Integrated Security=SSPI;");
            connection.Open();
            var select = new SqlCommand("USE LR2; SELECT TOP(1000) ID,FirstName,LastName,MiddleName FROM Client ORDER BY ID DESC", connection);
            var reader = select.ExecuteReader();
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    InfoBox.Items.Add(reader.GetString(1) + " " + reader.GetString(2) + " " + reader.GetString(3));
                }
            }
            reader.Close();
            var getCount = new SqlCommand("USE LR2; SELECT COUNT(*) FROM Client", connection);
            int CountRows = Convert.ToInt32(getCount.ExecuteScalar());
            CountLabel.Content = CountRows.ToString() + " rows";
            connection.Close();
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            var connection = new SqlConnection("Data Source=(local);Integrated Security=SSPI;");
            connection.Open();
            var StartTime = DateTime.Now;
            var select = new SqlCommand($"USE LR2; SELECT Client.ID,FirstName,LastName,MiddleName,StartDate FROM Client WITH (INDEX(ID_Index)) JOIN Rent ON Rent.ClientID = Client.ID ORDER BY Client.ID DESC", connection);
            var reader = select.ExecuteReader();
            TimeSpan diff = DateTime.Now - StartTime;
            TimeLabel.Content = $"completed in {diff.TotalSeconds} seconds";
            int i = 0;
            InfoBox.Items.Clear();
            if (reader.HasRows)
            {
                while (reader.Read() && i < 1000)
                {
                    InfoBox.Items.Add(reader.GetString(1) + " " + reader.GetString(2) + " " + reader.GetString(3) + " " + ((System.DateTime)reader[4]).ToShortTimeString());
                    i++;
                }
            }
            reader.Close();
            var getCount = new SqlCommand("USE LR2; SELECT COUNT(*) FROM Client", connection);
            int CountRows = Convert.ToInt32(getCount.ExecuteScalar());
            CountLabel.Content = CountRows.ToString() + " rows";
            connection.Close();
        }

        private void Button_Click_4(object sender, RoutedEventArgs e)
        {
            var connection = new SqlConnection("Data Source=(local);Integrated Security=SSPI;");
            connection.Open();
            var StartTime = DateTime.Now;
            var getLastID = new SqlCommand("USE LR2; SELECT TOP(1) ID FROM Client ORDER BY ID DESC", connection);
            int ID = Convert.ToInt32(getLastID.ExecuteScalar()) + 1;
            var r = new Random();
            var select = new SqlCommand($"USE LR2; SELECT Client.ID,FirstName,LastName,MiddleName FROM Client WITH (INDEX(ID_Index)) WHERE ID = {r.Next() % ID + 1} ORDER BY Client.ID DESC", connection);
            var reader = select.ExecuteReader();
            TimeSpan diff = DateTime.Now - StartTime;
            TimeLabel.Content = $"completed in {diff.TotalSeconds} seconds";
            int i = 0;
            InfoBox.Items.Clear();
            if (reader.HasRows)
            {
                while (reader.Read() && i < 1000)
                {
                    InfoBox.Items.Add(reader.GetString(1) + " " + reader.GetString(2) + " " + reader.GetString(3));
                    i++;
                }
            }
            reader.Close();
            var getCount = new SqlCommand("USE LR2; SELECT COUNT(*) FROM Client", connection);
            int CountRows = Convert.ToInt32(getCount.ExecuteScalar());
            CountLabel.Content = CountRows.ToString() + " rows";
            connection.Close();
        }

        private void Button_Click_3(object sender, RoutedEventArgs e)
        {
            var connection = new SqlConnection("Data Source=(local);Integrated Security=SSPI;");
            connection.Open();
            var StartTime = DateTime.Now;
            var select = new SqlCommand($"USE LR2; SELECT Client.ID,FirstName,LastName,MiddleName,StartDate FROM Client WITH (INDEX(0)) JOIN Rent ON Rent.ClientID = Client.ID ORDER BY Client.ID DESC", connection);
            var reader = select.ExecuteReader();
            TimeSpan diff = DateTime.Now - StartTime;
            TimeLabel.Content = $"completed in {diff.TotalSeconds} seconds";
            int i = 0;
            InfoBox.Items.Clear();
            if (reader.HasRows)
            {
                while (reader.Read() && i < 1000)
                {
                    InfoBox.Items.Add(reader.GetString(1) + " " + reader.GetString(2) + " " + reader.GetString(3) + " " + ((System.DateTime)reader[4]).ToShortTimeString());
                    i++;
                }
            }
            reader.Close();
            var getCount = new SqlCommand("USE LR2; SELECT COUNT(*) FROM Client", connection);
            int CountRows = Convert.ToInt32(getCount.ExecuteScalar());
            CountLabel.Content = CountRows.ToString() + " rows";
            connection.Close();
        }

        private void Button_Click_5(object sender, RoutedEventArgs e)
        {
            var connection = new SqlConnection("Data Source=(local);Integrated Security=SSPI;");
            connection.Open();
            var StartTime = DateTime.Now;
            var getLastID = new SqlCommand("USE LR2; SELECT TOP(1) ID FROM Client ORDER BY ID DESC", connection);
            int ID = Convert.ToInt32(getLastID.ExecuteScalar()) + 1;
            var r = new Random();
            var select = new SqlCommand($"USE LR2; SELECT Client.ID,FirstName,LastName,MiddleName FROM Client WITH (INDEX(0)) WHERE ID = {r.Next() % ID + 1} ORDER BY Client.ID DESC", connection);
            var reader = select.ExecuteReader();
            TimeSpan diff = DateTime.Now - StartTime;
            TimeLabel.Content = $"completed in {diff.TotalSeconds} seconds";
            int i = 0;
            InfoBox.Items.Clear();
            if (reader.HasRows)
            {
                while (reader.Read() && i < 1000)
                {
                    InfoBox.Items.Add(reader.GetString(1) + " " + reader.GetString(2) + " " + reader.GetString(3));
                    i++;
                }
            }
            reader.Close();
            var getCount = new SqlCommand("USE LR2; SELECT COUNT(*) FROM Client", connection);
            int CountRows = Convert.ToInt32(getCount.ExecuteScalar());
            CountLabel.Content = CountRows.ToString() + " rows";
            connection.Close();
        }
    }
}
