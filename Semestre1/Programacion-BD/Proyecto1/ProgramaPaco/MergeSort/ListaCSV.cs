using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public class ListaCSV
{
    private List<int> vector;

    public List<int> ObtenerArrayDesdeCSV(string rutaArchivo)
    {
        if (!File.Exists(rutaArchivo))
        {
            throw new FileNotFoundException("El archivo no existe.");
        }

        try
        {
            string contenido = File.ReadAllText(rutaArchivo);

            vector = contenido.Split(',')  
                            .Select(int.Parse) 
                            .ToList();
            return vector;
        }
        catch (FormatException)
        {
            throw new FormatException("El archivo CSV contiene valores no enteros.");
        }
    }

    

}