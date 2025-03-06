using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


public class MergeSort
{
    public static int numeroDeElementos;
    public static int intercambios;
    public static int comparaciones;

    public static List<int> ordenarVector(List<int> vector)
    {

        if (vector.Count <= 1)
        {
            return vector;
        }
        //----------Division de arreglo----------------
        int mitad = vector.Count / 2;
        List<int> mitad1 = new List<int>();
        List<int> mitad2 = new List<int>();
        for (int i = 0; i <= mitad + (vector.Count % 2) - 1; i++)
        {
            mitad1.Add(vector[i]);
        }
        //imprimirDatos(mitad1);
        for (int i = mitad + (vector.Count % 2); i < vector.Count; i++)
        {
            mitad2.Add(vector[i]);
        }
        //imprimirDatos(mitad2);
        //Console.WriteLine();

        //Recursividad en división del arreglo
        mitad1 = ordenarVector(mitad1);
        mitad2 = ordenarVector(mitad2);

        List<int> vectorOrdenado = UnirVectores(mitad1,mitad2);

        return vectorOrdenado;

    }

    public static List<int> UnirVectores(List<int> lista1, List<int> lista2)
    {
        List<int> resultado = new List<int>();
        int i = 0;
        int j = 0;

        while(i < lista1.Count && j < lista2.Count)
        {
            if (lista1[i] <= lista2[j])
            {
                resultado.Add(lista1[i]);
                i++;
            }
            else
            {
                resultado.Add(lista2[j]);
                j++;
            }
            comparaciones++;
            intercambios++;
        }

        while (i < lista1.Count)
        {
            resultado.Add(lista1[i]);
            i++;
            intercambios++;
            
        }
        while (j < lista2.Count)
        {
            resultado.Add(lista2[j]);
            j++;
            intercambios++;
        }
        //imprimirDatos(resultado);
        //Console.WriteLine();

        numeroDeElementos = resultado.Count;
        return resultado;
    }

    public static void generarArchivosCSV(List<int> datos)
    {
        string contenidoCSV = string.Join(",", datos);
        string rutaArchivo = "listaOrdenada.csv";
        File.WriteAllText(rutaArchivo, contenidoCSV);
        Console.WriteLine($"El archivo CSV con la lista ordenada se generó correctamente en: {rutaArchivo}");

        int[] metricas = {numeroDeElementos, intercambios, comparaciones};
        string contenidoCSV2 = string.Join(",", metricas);
        string rutaArchivo2 = "datosAlgoritmo.csv";
        File.WriteAllText(rutaArchivo2, contenidoCSV2);
        Console.WriteLine($"El archivo CSV con los datos del algoritmo se generó correctamente en: {rutaArchivo2}");
    }


    public static void imprimirDatos(List<int> vector)
    {
        Console.Write("[");
        for (int i = 0; i < vector.Count - 1; i++)
        {
            Console.Write(vector[i] + ", ");
        }
        Console.Write(vector[vector.Count - 1]);
        Console.Write("]   ");
    }
}

