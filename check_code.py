#coding=utf-8
import os
import io
import sys

def alter(base_path,file_name,old_str):
    """
    替换文件中的字符串
    :param file:文件名
    :param old_str:就字符串
    :param new_str:新字符串
    :return:
    """
    file = os.path.join(base_path,file_name)
    with io.open(file, "r", encoding="utf-8") as f:
        for line in f:
            if old_str in line:
                print('zc see5>', line)
                str = 'Code format error in'+file+';code like>'+'['+old_str+']'
                raise RuntimeError(str)
 
#获取目录下的文件
def files(dir):   
	for root,dirs,files in os.walk(dir): 
		return (files)

def dirs(dir):   
	for root,dirs,files in os.walk(dir): 
		return (dirs)

#获取后缀名
def file_extension(file):
  return os.path.splitext(file)[1]

def doit(base_path):
    print('zc see1>',base_path)
    file_list = files(base_path)
    print('zc see2>',file_list)
    for i in file_list:
        if file_extension(i) == '.m' or file_extension(i) == '.h':
           alter(base_path,i,'-(')
    
    dir_list = dirs(base_path)
    for i in dir_list:
        new_path = os.path.join(base_path,i)
        doit(new_path)

def main():
    abspath = os.path.abspath('.')
    doit(abspath)

if __name__ == '__main__':
    main()
    
