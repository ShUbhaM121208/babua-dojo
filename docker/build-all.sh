# Docker Build Script for All Judge Containers

# Build JavaScript container
echo "Building JavaScript judge container..."
cd javascript
docker build -t babua-judge-js:latest .
cd ..

# Build Python container
echo "Building Python judge container..."
cd python
docker build -t babua-judge-python:latest .
cd ..

# Build C++ container
echo "Building C++ judge container..."
cd cpp
docker build -t babua-judge-cpp:latest .
cd ..

# Build Java container
echo "Building Java judge container..."
cd java
docker build -t babua-judge-java:latest .
cd ..

# Build C container
echo "Building C judge container..."
cd c
docker build -t babua-judge-c:latest .
cd ..

echo "All containers built successfully!"
echo ""
echo "To test a container, run:"
echo "docker run --rm -v /path/to/code:/sandbox babua-judge-js:latest"
