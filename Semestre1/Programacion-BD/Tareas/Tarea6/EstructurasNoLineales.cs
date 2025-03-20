using System;

class Matrices
{
    static int[,] Matriz = new int[3, 3];
    static int[] Vector = new int[9];

    static void LlenaMatriz() {
        Matriz[0, 0] = 6;
        Matriz[1, 0] = 8;
        Matriz[2, 0] = 9;
        Matriz[0, 1] = 1;
        Matriz[1, 1] = 3;
        Matriz[2, 1] = 20;
        Matriz[0, 2] = 0;
        Matriz[1, 2] = 5;
        Matriz[2, 2] = 10;
    }

    static void MostrarDatosMatriz() {
        for (int f = 0; f < 3; f++) {
            for (int c = 0; c < 3; c++)
            {
                Console.Write(Matriz[f, c] + " ");
            }
            Console.WriteLine();
        }
    }

    static void MostrarDatosVector() {
        for (int i = 0; i < Vector.Length; i++) {
            Console.Write(Vector[i] + " ");
        }
        Console.WriteLine();
    }

    static void Trasformacion2da1d() {
        int index = 0;
        for (int f = 0; f < Matriz.GetLength(0); f++) {
            for (int c = 0; c < Matriz.GetLength(1); c++) {
                Vector[index] = Matriz[f, c];
                index++;
            }
        }
    }

    static void Trasformacion1da2d() {
        int index = 0;
        for (int f = 0; f < Matriz.GetLength(0); f++) {
            for (int c = 0; c < Matriz.GetLength(1); c++) {
                Matriz[f, c] = Vector[index];
                index++;
            }
        }
    }
    
    static void insertionSort() {
    for (int i = 1; i < Vector.Length; i++) {
      int key = Vector[i];
      int j = i - 1;
      
      while (j >= 0 && Vector[j] > key) {
        Vector[j + 1] = Vector[j];
        j--;
      }
      
      Vector[j + 1] = key;
    }
  }

    static void Main() {
        LlenaMatriz();
        Console.WriteLine("Matriz Original:");
        MostrarDatosMatriz();

        Trasformacion2da1d();
        Console.WriteLine("\nVector Transformado:");
        MostrarDatosVector();

        insertionSort();
        Console.WriteLine("\nVector Ordenado:");
        MostrarDatosVector();

        Trasformacion1da2d();
        Console.WriteLine("\nMatriz Transformada de Regreso:");
        MostrarDatosMatriz();
    }
}
