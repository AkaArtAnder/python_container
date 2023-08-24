#This dockerfile for production
FROM python:3.11

COPY . /root/code

#install cpp extensions
# RUN apt-get install -y clangd, lldb
# RUN ln -s /usr/lib/llvm-14/lib/python3.11/dist-packages/lldb/* /usr/lib/python3/dist-packages/lldb/
