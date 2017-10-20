#include <iostream>

using namespace std;

typedef unsigned int uint;
const uint highBit = 2147483648;

class Allocator{
    void *memory,*memoryEnd;
    void merge(void* p){
        if (!((*((uint*)p)) & highBit)) return;
        size_t memorySize = (*((uint*)p)) ^ highBit;
        void* next = p + sizeof(uint) + memorySize;
        while (next<memoryEnd &&((*((uint*)next)) & highBit)){
            size_t addMemory = ((*((uint*)next)) ^ highBit);
            memorySize += addMemory + sizeof(uint);
            (*((uint*)p)) = memorySize | highBit;
            next = p + sizeof(uint) + memorySize;
        }
    }
    public:
    Allocator(){
        memory = new char[4096];
        memoryEnd = (char*)memory+4096;
        *((uint*)memory) = (4096-sizeof(uint)) | highBit;
    }
    Allocator(size_t memorySize){
        if (memorySize<5) return;
        memory = new char[memorySize];
        memoryEnd = (char*)memory+memorySize;
        *((uint*)memory) = (memorySize-sizeof(uint)) | highBit;
    }
    ~Allocator(){
        delete[] (char*)memory;
    }
    void* allocate(size_t memorySize){
        void* i=memory;
        while (i<memoryEnd)
        {
            if ((*((uint*)i)) & highBit)
            {
                merge(i);
                size_t blockSize = (*((uint*)i)) ^ highBit;
                if (blockSize>=memorySize){
                    if (blockSize > memorySize + sizeof(uint)){
                        size_t s2= blockSize - memorySize - sizeof(uint);
                        *((uint*)i) = highBit | memorySize;
                        void* j = i + sizeof(uint) + memorySize;
                        *((uint*)j) = highBit | s2;
                    }
                    *((uint*)i) ^= highBit;
                    return i+sizeof(uint);
                }
            }
            size_t blockSize = (*((uint*)i)) & (~highBit);
            i = i + sizeof(uint) + blockSize;
        }
        return 0;
    }
    void free(void* p){
        if (p<memory || p>=memoryEnd) return;
        if (((*((uint*)p)) & highBit)) return;
        p-=sizeof(uint);
        size_t memorySize = (*((uint*)p));
        (*((uint*)p)) ^= highBit;
    }
    void* realloc(void* p, size_t newSize){
        if (p<memory || p>=memoryEnd) return 0;
        if (((*((uint*)p)) & highBit)) return 0;
        p -= sizeof(uint);
        int curSize = (*((uint*)p));
        void* newPointer = allocate(newSize);
        p += sizeof(uint);
        for (char *i=(char*)p, *j=(char*)newPointer;i<p+curSize && i<p+newSize;i++,j++){
                *j = *i;
        }
        free(p);
        return newPointer;
    }

};

int main()
{
    Allocator a;
    int i=0;
    void *p1=a.allocate(124),*p2=a.allocate(124);
    cout << "124 bytes allocated:" <<p1 << " 124 more bytes allocated:" << p2 << endl;
    a.free(p1);
    a.free(p2);
    void* p = a.allocate(4092);
    cout << "free all memory" << endl;
    cout << "max memory allocated:" << p << endl;
    a.free(p);
    int* t = (int*)a.allocate(sizeof(int));
    *t = 12345;
    cout << "data before realloc:" << *t << " pointer:" << t << endl;
    t = (int*)a.realloc(t,sizeof(int));
    cout << "data after realloc:" << *t << " pointer:" << t << endl;
    return 0;
}
