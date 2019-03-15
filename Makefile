#!make -f
CXX=clang++-5.0
CXXFLAGS=-std=c++17 

all: 
	$(CXX) $(CXXFLAGS) *.cpp -lpthread
	./a.out 
