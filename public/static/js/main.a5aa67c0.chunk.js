(this.webpackJsonpclient=this.webpackJsonpclient||[]).push([[0],{63:function(e,t,a){e.exports=a(93)},68:function(e,t,a){},90:function(e,t,a){},93:function(e,t,a){"use strict";a.r(t);var n=a(1),r=a.n(n),c=a(22),l=a.n(c),u=(a(68),a(43),a(15)),o=a(40),i=a(33);var s=function(e){return r.a.createElement(r.a.Fragment,null,r.a.createElement(o.a,{bg:"secondary",variant:"dark",expand:"lg"},r.a.createElement(o.a.Brand,{href:"/entries"},"Mike Reader"),r.a.createElement(i.a,{className:"mr-auto"},r.a.createElement(i.a.Link,{href:"/feeds"},"Feeds"),r.a.createElement(i.a.Link,{href:"/entries"},"Entries"))))},m=a(24),f=a(54),d=a(61),E=a(30),h=a(31),g=a(18),b=a.n(g),p="/feeds",k=function(){function e(){Object(E.a)(this,e)}return Object(h.a)(e,null,[{key:"get",value:function(){return b.a.get(p+".json")}},{key:"put",value:function(e){return b.a.put([p,e.id+".json"].join("/"),e)}}]),e}(),v=a(13),y=a.n(v);var j=function(e){var t=e.updateMessages,a=r.a.useState([]),n=Object(u.a)(a,2),c=n[0],l=n[1],o=r.a.useCallback((function(e){t({danger:"There was an error."}),console.log(e)}),[t]),i=function(e){t({success:"Saved changes to '"+e.data.name+"'."})};r.a.useEffect((function(){k.get().then((function(e){l(e.data)})).catch(o)}),[o]);var s=function(e,t){return r.a.createElement(d.a.Switch,{key:e.id,onChange:function(e){!function(e,t){var a=Object(m.a)(c);a[e].display=t.target.checked,k.put(a[e]).then(i).catch(o),l(a)}(t,e)},id:"enable-switch-"+e.id,label:e.id,"aria-label":"Enable "+e.name,checked:e.display})};return r.a.createElement(r.a.Fragment,null,r.a.createElement(f.a,{striped:!0,responsive:!0,size:"sm"},r.a.createElement("thead",null,r.a.createElement("tr",null,r.a.createElement("th",null,"id"),r.a.createElement("th",null,"name"),r.a.createElement("th",null,"url"),r.a.createElement("th",null,"active?"))),r.a.createElement("tbody",null,c.map((function(e,t){var a=y.a.pick(e,["id","name","url"]),n=y.a.map(a,(function(e,t){return r.a.createElement("td",{key:t},e)}));return r.a.createElement("tr",{key:t},n,r.a.createElement("td",null,s(e,t)))})))))},O=a(59),w=a(55),x=a(23),M=a(56),C=a(57),S=a(58),L="/entries",N=function(){function e(){Object(E.a)(this,e)}return Object(h.a)(e,null,[{key:"getPods",value:function(){return b.a.get([L,"pods.json"].join("/"))}},{key:"get",value:function(){return b.a.get(L+".json")}},{key:"delete",value:function(e){return b.a.delete([L,e.id+".json"].join("/"))}}]),e}(),F=function(e){var t=[[240,163,255],[0,117,220],[153,63,0],[76,0,92],[25,25,25],[0,92,49],[43,206,72],[255,204,153],[128,128,128],[148,255,181],[143,124,0],[157,204,0],[194,0,136],[0,51,128],[255,164,5],[255,168,187],[66,102,0],[255,0,16],[94,241,242],[0,153,143],[224,255,102],[116,10,255],[153,0,0],[255,255,128],[255,255,0],[255,80,5]];return"rgb("+t[e%t.length].join()+")"},T=["border-top","entry"],_="mikefeed-ui-progressbar-overlay",B=["read"];var J=function(e){var t=e.updateMessages,a=e.entry,n=e.isLast,c={color:F(a.feed_id)},l=r.a.useState(T),o=Object(u.a)(l,2),i=o[0],s=o[1],f=r.a.useCallback((function(e){s((function(e){return y.a.without(e,_)})),t({danger:"There was an error."}),console.log(e)}),[t]),d=function(){s((function(e){return[B].concat(Object(m.a)(y.a.without(e,_)))}))},E=function(){window.open(a.link,"_blank"),h()},h=function(){s((function(e){return[_].concat(Object(m.a)(e))})),N.delete(a).then(d).catch(f)};return r.a.useEffect((function(){!0===n&&s((function(e){return["border-bottom"].concat(Object(m.a)(e))}))}),[n]),r.a.createElement(w.a,{key:a.id,className:i},r.a.createElement(x.a,{variant:"light",xs:"auto",as:M.a},r.a.createElement(C.a,null)),r.a.createElement(x.a,{xs:"auto",className:"align-self-center",onClick:E},r.a.createElement(S.a,{style:c})),r.a.createElement(x.a,{className:"text-truncate align-self-center",onClick:E},r.a.createElement("a",{className:"text-decoration-none",style:{corationLine:"none",color:"black"},rel:"noopener noreferrer",target:"_blank",href:a.link},a.subject)))};var z=function(e){var t=e.updateMessages,a=r.a.useState([]),n=Object(u.a)(a,2),c=n[0],l=n[1],o=r.a.useCallback((function(e){t({danger:"There was an error."}),console.log(e)}),[t]);return r.a.useEffect((function(){N.get().then((function(e){l(e.data)})).catch(o)}),[o]),r.a.createElement(O.a,{fluid:!0},c.map((function(e,a){return r.a.createElement(J,{updateMessages:t,key:e.id,isLast:c.length-1===a,entry:e})})))},H=a(41),I=a(62),P=a(6);a(90);var R=function(){var e=r.a.useState({}),t=Object(u.a)(e,2),a=t[0],n=t[1],c=function(e){n(e)};return r.a.createElement(r.a.Fragment,null,r.a.createElement(I.a,null,r.a.createElement(s,null),y.a.isEmpty(a)?r.a.createElement(H.a,{style:{minHeight:"50px"}}," "):y.a.map(a,(function(e,t){return r.a.createElement(H.a,{key:t,variant:t,dismissible:!0,onClose:function(){n()}},e)})),r.a.createElement(P.d,null,r.a.createElement(P.b,{exact:!0,path:"/"},r.a.createElement(P.a,{to:"/entries"})),r.a.createElement(P.b,{path:"/feeds"},r.a.createElement(j,{updateMessages:c})),r.a.createElement(P.b,{path:"/entries"},r.a.createElement(z,{updateMessages:c})))))};l.a.render(r.a.createElement(r.a.StrictMode,null,r.a.createElement(R,null)),document.getElementById("root"))}},[[63,1,2]]]);
//# sourceMappingURL=main.a5aa67c0.chunk.js.map