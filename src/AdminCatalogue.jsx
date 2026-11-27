import React,{useEffect,useState} from 'react';
import {supabase} from './lib/supabase';
import {Plus,Save,Image as ImageIcon,Eye,EyeOff,Trash2,RefreshCw} from 'lucide-react';
const blank={id:null,slug:'',name:'',description:'',category:'kota',price:'',image_url:'',ingredients:[],is_available:true,is_published:true,sort_order:10};
const money=n=>new Intl.NumberFormat('en-ZA',{style:'currency',currency:'ZAR'}).format(Number(n||0));
export default function AdminCatalogue({notify=()=>{}}){
 const [rows,setRows]=useState([]),[draft,setDraft]=useState(blank),[loading,setLoading]=useState(true),[saving,setSaving]=useState(false),[ingredientText,setIngredientText]=useState('');
 async function load(){setLoading(true);const {data,error}=await supabase.from('products').select('*').order('sort_order');if(error)notify(error.message);else setRows(data||[]);setLoading(false)}
 useEffect(()=>{load()},[]);
 function edit(p){setDraft({...p,price:String(p.price),ingredients:p.ingredients||[]});setIngredientText((p.ingredients||[]).join(', '));window.scrollTo({top:0,behavior:'smooth'})}
 function fresh(){setDraft({...blank});setIngredientText('')}
 async function save(e){e.preventDefault();setSaving(true);const payload={slug:draft.slug.trim()||draft.name.toLowerCase().trim().replace(/[^a-z0-9]+/g,'-').replace(/^-|-$/g,''),name:draft.name.trim(),description:draft.description.trim(),category:draft.category,price:Number(draft.price),image_url:draft.image_url.trim()||null,ingredients:ingredientText.split(',').map(x=>x.trim()).filter(Boolean),is_available:draft.is_available,is_published:draft.is_published,sort_order:Number(draft.sort_order)||0,is_demo:false,updated_at:new Date().toISOString()};
 const q=draft.id?supabase.from('products').update(payload).eq('id',draft.id):supabase.from('products').insert(payload);
 const {error}=await q;setSaving(false);if(error){notify(error.message);return}notify('Catalogue item saved.');fresh();load()}
 async function toggle(p,field){const {error}=await supabase.from('products').update({[field]:!p[field],updated_at:new Date().toISOString()}).eq('id',p.id);if(error)notify(error.message);else{setRows(old=>old.map(x=>x.id===p.id?{...x,[field]:!p[field]}:x));notify(field==='is_published'?(p[field]?'Removed from public catalogue.':'Published to public catalogue.'):(p[field]?'Marked unavailable.':'Marked available.'))}}
 async function remove(p){if(!window.confirm('Delete '+p.name+'? Existing order history will retain its recorded product name and price.'))return;const {error}=await supabase.from('products').delete().eq('id',p.id);if(error)notify(error.message);else{notify('Catalogue item deleted.');load();if(draft.id===p.id)fresh()}}
 return <section className="catalogue-admin">
  <div className="catalogue-admin-head"><div><p className="eyebrow">PRODUCT & MENU CONTROL</p><h2>Catalogue <em>management.</em></h2><p>Manage names, descriptions, prices, imagery, ingredients and what customers can see or order.</p></div><button className="link" onClick={load}><RefreshCw size={15}/> Refresh</button></div>
  <form className="catalogue-editor" onSubmit={save}>
   <div className="catalogue-editor-title"><b>{draft.id?'Edit catalogue item':'Create catalogue item'}</b><button type="button" className="link" onClick={fresh}>Clear form</button></div>
   <div className="form-grid">
    <label>Product name<input required value={draft.name} onChange={e=>setDraft({...draft,name:e.target.value})} placeholder="The Classic Kota"/></label>
    <label>URL slug<input value={draft.slug} onChange={e=>setDraft({...draft,slug:e.target.value})} placeholder="classic-kota"/></label>
    <label>Category<select value={draft.category} onChange={e=>setDraft({...draft,category:e.target.value})}><option value="kota">Kota</option><option value="meals">Meals</option><option value="beverages">Beverages</option><option value="other">Other</option></select></label>
    <label>Price (ZAR)<input type="number" required min="0" step="0.01" value={draft.price} onChange={e=>setDraft({...draft,price:e.target.value})} placeholder="15.00"/></label>
    <label className="full">Short description<textarea rows="2" value={draft.description} onChange={e=>setDraft({...draft,description:e.target.value})}/></label>
    <label className="full">Image URL<input value={draft.image_url||''} onChange={e=>setDraft({...draft,image_url:e.target.value})} placeholder="https://… or /images/…"/><small>Use an approved hosted image URL. Preview below.</small></label>
    {draft.image_url&&<div className="catalogue-image-preview"><img src={draft.image_url} alt="Product preview" onError={e=>e.currentTarget.style.opacity='.25'}/><span><ImageIcon size={14}/> Image preview</span></div>}
    <label className="full">Ingredients / included fillings<input value={ingredientText} onChange={e=>setIngredientText(e.target.value)} placeholder="Bread, polony, cheese, atchar, chips"/><small>Separate each ingredient with a comma. These appear on the customer-facing Kota cards.</small></label>
    <label>Display order<input type="number" step="1" value={draft.sort_order} onChange={e=>setDraft({...draft,sort_order:e.target.value})}/></label>
   </div>
   <div className="catalogue-switches">
    <label><input type="checkbox" checked={draft.is_available} onChange={e=>setDraft({...draft,is_available:e.target.checked})}/> Available to order</label>
    <label><input type="checkbox" checked={draft.is_published} onChange={e=>setDraft({...draft,is_published:e.target.checked})}/> Visible in public menu</label>
   </div>
   <div className="catalogue-actions"><button className="btn dark" disabled={saving}>{saving?'Saving…':<><Save size={15}/> Save catalogue item</>}</button><button type="button" className="link" onClick={fresh}>Cancel</button></div>
  </form>
  <div className="catalogue-list-head"><h3>All catalogue items <span>{rows.length}</span></h3></div>
  {loading?<p>Loading catalogue…</p>:<div className="catalogue-list">{rows.map(p=><article className="catalogue-row" key={p.id}><img src={p.image_url||'/images/maake-kota.webp'} alt=""/><div className="catalogue-row-info"><b>{p.name}</b><small>{p.category} · {money(p.price)} · Order {p.sort_order}</small><p>{p.description}</p><small>{(p.ingredients||[]).join(' · ')}</small><div className="catalogue-status"><span className={p.is_published?'is-on':'is-off'}>{p.is_published?'Published':'Hidden'}</span><span className={p.is_available?'is-on':'is-off'}>{p.is_available?'Available':'Unavailable'}</span></div></div><div className="catalogue-row-actions"><button title={p.is_published?'Hide from menu':'Publish to menu'} onClick={()=>toggle(p,'is_published')}>{p.is_published?<EyeOff size={16}/>:<Eye size={16}/>}</button><button title={p.is_available?'Mark unavailable':'Mark available'} onClick={()=>toggle(p,'is_available')}>{p.is_available?'Pause':'Enable'}</button><button onClick={()=>edit(p)}>Edit</button><button title="Delete item" onClick={()=>remove(p)}><Trash2 size={15}/></button></div></article>)}</div>}
 </section>
}