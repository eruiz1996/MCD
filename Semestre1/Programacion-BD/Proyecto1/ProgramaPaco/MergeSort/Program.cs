using System;

class Program
{
    static void Main()
    {
        string nombreArchivoLista = "lista.csv";
        ListaCSV lista = new ListaCSV();
        try
        {
            List<int> datos = lista.ObtenerArrayDesdeCSV(nombreArchivoLista);
            imprimirDatos(datos);
            List<int> datosOrdenados = MergeSort.ordenarVector(datos);
            MergeSort.generarArchivosCSV(datosOrdenados);
            imprimirDatos(datosOrdenados);
            Console.WriteLine("Comparaciones: " + MergeSort.comparaciones);
            Console.WriteLine("Intercambios: "+MergeSort.intercambios);
        }
        catch (Exception e)
        {
            Console.WriteLine(e.Message);
        }


    }

    public static void imprimirDatos(List<int> vector)
    {
        Console.Write("[");
        for (int i = 0; i < vector.Count - 1; i++)
        {
            Console.Write(vector[i] + ", ");
        }
        Console.Write(vector[vector.Count - 1]);
        Console.Write("]");
        Console.WriteLine();
    }
}
