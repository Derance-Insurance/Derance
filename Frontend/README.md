# Derance Insurance Frontend

## Build setup
```
# clone the project
git clone https://github.com/Derance-Insurance/Derance.git

# enter the project directory
cd derance/frontend

# install dependency
npm install

# set nodejs memory, avoid out of memory
npm run fix-memory-limit

# develop
npm run dev
```

## Build
```
# enter the project directory
cd derance/frontend

# build for production environment
npm run build

# copy all files to web work dir
cp -r dist/* /usr/nginx/html
```


