---
title: "Markdown Kullanımı"
author: "Veysi Bingöl"
date: "30/01/2024"
---

# Giriş 

Bu belgede markdown kullanımının öğretilmesi amaçlanmıştır.

## Üzerinde Durulacak Konular

1. Başlık ekleme
2. Alt başlıkları ekleme
3. Vurgulamalar 
4. Madde ekleme ve sıralama 
5. Bağlantı ekleme
6. Kod ekleme
7. Tablo ekleme
8. Görsel ekleme

### Başlık Ekleme

Markdown kullanırken başlık eklemek amacıyla `#` kullanılır. Örneğin `# Staj` yazıldığı durumda başlık `Staj` şeklinde görünecektir. 

```markdown
# Staj
```

### Alt Başlıklar Ekleme

Başlığın altına alt başlıklar eklenmek isteniyorsa, oluşturulacak her alt başlık için fazladan bir `#` eklenir. Örneğin staj başlığı altında `zorunlu staj 1` yazılması istendiği zaman, bunun `## zorunlu staj 1` şeklinde yazılması gerekir. 

Eğer `zorunlu staj 1` alt başlığının alt başlıkları varsa yazılacak alt başlıklar için fazladan bir `#` daha eklenir. Örneğin bu alt başlıklardan biri `1. gün` olsun. Bunun başlık şeklinde yazılması için `### 1. gün ` şeklinde yazılması gerekir. 

### Vurgulamalar

Markdown kullanırken kelime ya da cümlelerin vurgulanması farklı şekillerde yapılabilir. 

#### Metni Kalın Şekilde Yazma

Kelime veya cümlenin kalın yazılması için;

```markdown 
**kelime** ya da __kelime__
```

Bunun çıktısı şu şekilde görünecektir:

**kelime** ya da __kelime__

#### Metni İtalik Şekilde Yazma

Kelime veya cümlenin italik yazılması için;

```markdown
*kelime* ya da _kelime_ 
```

şeklinde yazılması gerekir. 

Bunun çıktısı şu şekilde görünecektir:

*kelime* ya da _kelime_

#### Kalın ve İtalik Yazma

Kelime veya cümlenin hem kalın hem italik yazılması için;

```markdown
***kelime*** ya da ___kelime___
```

şeklinde yazılması gerekir.

Bunun çıktısının

***kelime*** ya da ___kelime___

şeklinde yazılması gerekir. 

### Madde Ekleme ve Sıralama

#### Madde Ekleme

Markdown kullanırken madde eklenmesi isteniyorsa satır başına `+` ya da `-` eklemek yeterli olacaktır. Örneğin hücre organellerinin maddeler halinde yazılması isteniyorsa her satır başına `+` ya da `-` konması yeterli olacaktır. 

örneğin; 

```markdown
+ kloroplast
+ mitokondri
+ endoplazmik retikulum...
```

yazıldığı zaman elde edilen çıktı:

+ kloroplast
+ mitokondri
+ endoplazmik retikulum...

şeklinde olacaktır. 

#### Sıralama 

Sıralama yapılırken madde ekleme ile benzer bir mantık yürütülür. bunun için satır başına `1.` yazılırsa sıralama yapılacaktır. 

Örneğin;

```markdown
1. a
2. b
3. c
```

yazıldığı zaman elde edilen çıktı

1. a
2. b
3. c

şeklinde olacaktır. 

###  Bağlantı Ekleme

Markdown kullanılırken bağlantı eklenmesi isteniyorsa 

```markdown
[bağlantı adı](bağlantı)
```

 şeklinde yazılması uygun olacaktır. Örneğin komut satırına 

 ```markdown
 [nature](https://www.nature.com/)
 ```

yazılması durumunda elde edilen çıktı [nature](https://www.nature.com/) şeklinde olacaktır. 

### Kod Ekleme

Markdown kullanırken satır içine kod eklenmesi isteniyorsa

```
`kod`
```

şeklinde yazılması yeterli olacaktır. Bu bize satır içinde `kod` yazımını sağlayacaktır. 

Eğer kod bloğu eklemek istersek şu karakterleri kullanmalıyız:

~~~
```
kod
```
~~~

yazıldığı zaman ekranda yazılan çıktı:

```
kod
``` 

şeklinde olacaktır. 

### Tablo ekleme

Tablo eklerken aşağıdaki girdinin çıktısı tablodaki gibi oalcaktır. 

```markdown
|    |  x   |  y   |
|----|:-----|-----:|
|a   |  dld |  sls |
|b   |  hkh |  tyt |
```

|    |  x   |  y   |
|----|:-----|-----:|
|a   |  dld |  sls |
|b   |  hkh |  tyt |

### Görsel Ekleme

Markdown kullanırken görsel eklenmesi bağlantı ekleme ile benzer bir mantıkla yapılır. bunun için 

```markdown
![altyazı](resim adresi)
```

şeklinde yazılması uygun olacaktır. örneğin komut satırına

```markdown
![markdown](https://icons.veryicon.com/png/o/object/material_design_icons/markdown-1.png)
```

yazılması durumunda elde edilecek çıktı

![markdown](https://icons.veryicon.com/png/o/object/material_design_icons/markdown-1.png)

 şeklinde olacaktır. 