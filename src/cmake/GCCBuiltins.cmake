# Compiler features

check_c_source_compiles(
    "unsigned int x = 11; int main() { return __builtin_clz(x); }"
    HAVE__BUILTIN_CLZ)
check_c_source_compiles(
    "unsigned int x = 11; int main() { return __builtin_popcount(x); }"
    HAVE__BUILTIN_POPCOUNT)
check_c_source_compiles(
    "int main() { __sync_synchronize(); return 0;}"
    HAVE__SYNC_SYNCHRONIZE)
check_c_source_compiles(
    "long long v = 1; int main() { return __sync_add_and_fetch(&v, 1); }"
    HAVE___SYNC_ADD_AND_FETCH_8)
check_c_source_compiles(
    "int i=0; int main() { return __builtin_expect(i, 0) ? 0 : 1; }"
    HAVE___BUILTIN_EXPECT)
check_c_source_compiles(
    "__thread int i=0; int main() { return 0; }"
    HAVE___THREAD)
check_c_source_compiles(
    "volatile int i=0; int main() { return 0; }"
    HAVE_VOLATILE)
check_c_source_compiles(
    "int foo __attribute__((visibility (\"hidden\"))) = 1; int main() { return 0; }"
    HAVE_VISIBILITY_ATTRIBUTE)
check_c_source_compiles(
    "static inline foo() { return 0; } int main() { return foo(); }"
    HAVE_INLINE)

# Builtin functions that lead to conflicts

check_c_source_compiles(
    "int main() { char *s = alloca(10); return s!=0; }"
    HAVE_ALLOCA)
check_c_source_compiles(
    "#include <math.h>\nint main() { double x; return signbit(x); }"
    HAVE_SIGNBIT)
