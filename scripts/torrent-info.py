import sys
def dec(b,i=0):
    c=b[i:i+1]
    if c==b'i': j=b.index(b'e',i); return int(b[i+1:j]), j+1
    if c==b'l':
        i+=1; out=[]
        while b[i:i+1]!=b'e': v,i=dec(b,i); out.append(v)
        return out,i+1
    if c==b'd':
        i+=1; out={}
        while b[i:i+1]!=b'e': k,i=dec(b,i); v,i=dec(b,i); out[k]=v
        return out,i+1
    j=b.index(b':',i); n=int(b[i:j]); return b[j+1:j+1+n], j+1+n
for p in sys.argv[1:]:
    t,_=dec(open(p,'rb').read()); info=t[b'info']
    name=info[b'name'].decode(); files=info.get(b'files')
    if files:
        tot=sum(f[b'length'] for f in files); n=len(files)
        top=sorted(files,key=lambda f:-f[b'length'])[:6]
    else:
        tot=info[b'length']; n=1; top=[]
    print(f"{p}: name={name!r} files={n} total={tot/1e9:.1f} GB  trackers={len(t.get(b'announce-list',[]))} webseeds={t.get(b'url-list')}")
    for f in top: print(f"   {f[b'length']/1e9:7.2f} GB  {b'/'.join(f[b'path']).decode(errors='replace')}")
