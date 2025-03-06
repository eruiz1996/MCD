using System;
class SortingAlgorithms {
    
  static void Main() {
    int[] arr = {6, 1, 0, 8, 3, 5, 9, 20};
    
    Console.WriteLine("Arreglo original:");
    printArray(arr);
    
    insertionSort(arr);
    
    Console.WriteLine("Arreglo ordenado con Insertion Sort:");
    printArray(arr);
  }

  static void insertionSort(int[] arr) {
    for (int i = 1; i < arr.Length; i++) {
      int key = arr[i];
      int j = i - 1;
      
      while (j >= 0 && arr[j] > key) {
        arr[j + 1] = arr[j];
        j--;
      }
      
      arr[j + 1] = key;
    }
  }

  static void printArray(int[] arr) {
    Console.WriteLine(string.Join(", ", arr));
  }
}
