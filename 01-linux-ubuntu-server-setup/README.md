# 01 - Ubuntu Server Kurulumu (UTM ile GUI'sız)

Bu bölümde Ubuntu Server’ı Mac üzerinde **UTM** kullanarak GUI’sız bir şekilde kurma sürecini adım adım anlatıyorum.  
Bölüm içeriği:  
- Ubuntu Server ISO dosyasının indirilmesi  
- UTM ile sanal makine kurulumu  
- CPU, RAM ve disk gibi kaynak ayarlarının yapılması  

---

## 1. Video Anlatım

Bu README, aşağıdaki YouTube videosuyla eşlik etmektedir.  
Uygun adımları daha net görebilmek için videoyu izleyebilirsin.

📺 **Video linki**:  
https://www.youtube.com/watch?v=_qQ3CdMgU84

---

## 2. Gerekli Araçlar

Aşağıdaki araçları önceden kurduğunuzdan emin olun:

- Mac bilgisayar  
- [UTM](https://mac.getutm.app/)  
- [Ubuntu Server LTS](https://ubuntu.com/download/server) ISO dosyası  

---

## 3. ISO Dosyası Nasıl İndirilir?

1. Tarayıcıdan Ubuntu Server indirme sayfasına gidin:  
   https://ubuntu.com/download/server  
2. “Ubuntu Server” bölümünden **LTS** sürümünü seçin.  
3. “Download” butonuna tıklayıp ISO dosyasını bilgisayarınıza indirin.  

![1 - ISO İndirme Sayfası](step1-iso-download.png)

---

## 4. UTM ile Sanal Makine Kurulumu

1. UTM uygulamasını başlatın.  
2. `Create a New Virtual Machine` seçeneğini seçin.  
3. **Virtualization** modunda Ubuntu Server’ı seçin veya “Custom” seçeneği ile daha sonra ISO’yu seçin.  
4. ISO dosyasını bağlayıp sanal makine kurulumuna başlayın.  

![2 - UTM Sanal Makine Oluşturma](step2-utm-newvm.png)

---

## 5. Kaynak Ayarlamaları (CPU, RAM, Disk)

Kurulumdan sonra sanal makine ayarlarından kaynakları optimize edebilirsiniz:

- **CPU**: 2 vCPU  
- **RAM**: 2–4 GB (sunucu kullanımına göre)  
- **Disk**: 20 GB (dynamically allocated)  
- **Ağ**: Bridged veya NAT modu  

Bu değerleri sisteminizin yüküne göre artırabilirsiniz.

![3 - Kaynak Ayarları](step3-resources.png)

---


## 6. Notlar & Yardım

- Repo’yu kendi IT destek öğrenme yolculuğunuzda örnek bir kaynak olarak kullanabilirsiniz.  
- Uygulama veya komutlar hakkında sorun yaşadığınızda, lütfen **Issues** bölümünde soru açın veya YouTube videonun yorumlarına yazın.  

Bu README, `it-support-learning-journey` eğitim yolculuğunuzun ilk adımıdır.  
İleri seviye konular için daha fazla bölüm eklenecektir. 🚀
