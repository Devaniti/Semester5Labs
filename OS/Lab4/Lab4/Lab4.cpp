// Lab4.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <string>
#include <iostream>
#include <Windows.h>

using namespace std;

const size_t cluster_size = 512;

struct FileDescriptor {
	char name[128];
	unsigned long size;
	unsigned long offset;
	void print() const{
		cout << "name: " << name << " size:" << size << " offset:" << offset << "\n";
	}
};

struct ChunkData {
	unsigned long chunkSize;
	unsigned long nextChunkOffset;
	unsigned short links;
};

class FS {
private:
	struct FSDescriptor 
	{
		unsigned short size;
		FileDescriptor Descriptors[2048];
	} FSData;
	HANDLE FSHandle;
	bool opened[8192];
	unsigned long DataOffset;
	unsigned long DataEnd;
	unsigned long FSSize() 
	{
		DWORD A, B;
		B = GetFileSize(FSHandle, &A);
		return ((unsigned long)A) << sizeof(DWORD) || B;
	}
	void Seek(unsigned long offset)
	{
		SetFilePointer(FSHandle, offset, NULL, 0);
	}
	void ReadData(void* buffer, unsigned long length, unsigned long offset) {
		Seek(offset);
		DWORD read;
		WriteFile(FSHandle, buffer, length, &read, NULL);
	}
	void WriteData(void* buffer, unsigned long length, unsigned long offset) {
		Seek(offset);
		DWORD read;
		WriteFile(FSHandle, buffer, length, &read, NULL);
	}
public:
	FS(string path) {
		memset(opened, 0, sizeof(opened));
		FSHandle = CreateFileA(path.c_str(), GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
		DataOffset = sizeof(FSDescriptor);
		DataOffset += (-DataOffset) % cluster_size;
		if (GetLastError() != ERROR_ALREADY_EXISTS)
		{
			FSData.size = 0;
			WriteData(&FSData, sizeof(FSDescriptor), 0);
			DataEnd = DataOffset;
		}
		else
		{
			ReadData(&FSData, sizeof(FSDescriptor), 0);
			DataEnd = FSSize();
		}
	}
	~FS() {
		CloseHandle(FSHandle);
	}
	void ListFiles() const{
		cout << "FS Contains " << FSData.size << " descriptors\n";
		for (int i = 0; i < FSData.size; i++)
		{
			cout << "Descriptor " << i << ": ";
			FSData.Descriptors[i].print();
		}
	}
	FileDescriptor* GetFile(int id) {
		if (id >= FSData.size || id < 0) return nullptr;
		return FSData.Descriptors + id;
	}
} *CurrentFS;

int main()
{
	cout << "Bulatov FS implementation\n";
	while (1)
	{
		string inp;
		cout << ">";
		cin.clear();
		getline(cin, inp);
		if (!inp.compare(0,4,"exit"))
		{
			return 0;
		}
		else
		if (!inp.compare(0, 5, "mount"))
		{
			if (CurrentFS)
			{
				cout << "FS already mounted\n";
			}
			else
			if (inp.size()<7)
			{
				cout << "FS location is required\n";
			}
			else
			if (inp[5]!=' ')
			{
				cout << "unknown command\n";
			}
			else
			{
				CurrentFS = new FS(inp.substr(6));
				cout << "Succesfully mounted\n";
			}
		}
		else
		if (!inp.compare(0, 6, "umount"))
		{
			if (!CurrentFS)
			{
				cout << "FS not mounted\n";
			}
			else
			{
				delete CurrentFS;
				cout << "Succesfully unmounted\n";
			}
		}
		else
		if (!inp.compare(0, 2, "ls"))
		{
			if (!CurrentFS)
			{
				cout << "FS not mounted\n";
			}
			else
			{
				CurrentFS->ListFiles();
			}
		}
		else
		if (!inp.compare(0, 8, "filestat"))
		{
			if (!CurrentFS)
			{
				cout << "FS not mounted\n";
			}
			else
			if (inp.size()<10)
			{
				cout << "File id is required\n";
			}
			else
			{
				FileDescriptor* c = CurrentFS->GetFile(atoi(inp.substr(10).c_str()));
				if (c)
					c->print();
				else
					cout << "Bad id\n";

			}
		}
		else
		{
			cout << "unknown command\n";
		}
	}
    return 0;
}

