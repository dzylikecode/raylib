@Deprecated('Use add instead')
int add(int a, [int b = 0]) => a + b;


/// a basic function to demonstrate the use of @Deprecated
const add2 = add;

int main() {
  add2(1); // 3
  return 0;
}