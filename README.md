# secure-app
example app which implements security

## List branch
## 1. Code Obfuscation

Before | After 
:-------------------------: | :-------------------------: 
![Code Obfuscation - Before](https://user-images.githubusercontent.com/15220788/110627212-42e0a300-81d4-11eb-8208-e2443ac9e61c.png) | ![Code Obfuscation - After](https://user-images.githubusercontent.com/15220788/110627392-7fac9a00-81d4-11eb-9616-1e5152186388.png)


## 2. Root/Jailbreak Detection
<table>
  <tr>
    <td align="center"><b>Root</b></td>
    <td align="center"><b>Jailbreak</b></td>
  <tr>
  <tr>
    <td> <img src="https://user-images.githubusercontent.com/15220788/110627764-efbb2000-81d4-11eb-9ee5-a5843028f9af.gif" alt="Root Detection" height=640px></td>
    <td> <img src="https://user-images.githubusercontent.com/15220788/110628449-97d0e900-81d5-11eb-987d-32300f74d092.gif" alt="Jailbreak Detection" height=640px></td>
 </tr> 
</table>

## 3. SSL Pinning
* Android
<table>
  <tr>
    <td align="center"><b>Valid Certificate</b></td>
    <td align="center"><b>Not Valid Certificate</b></td>
  <tr>
  <tr>
    <td> <img src="https://user-images.githubusercontent.com/15220788/110632993-d2895000-81da-11eb-8d45-b20ccc6ff3de.gif" alt="SSL Pinning Android - Valid Certificate" height=640px></td>
    <td> <img src="https://user-images.githubusercontent.com/15220788/110633036-dc12b800-81da-11eb-9f96-8024fdb33710.gif" alt="SSL Pinning Android - Not Valid Certificate" height=640px></td>
 </tr> 
</table>

* iOS
<table>
  <tr>
    <td align="center"><b>Valid Certificate</b></td>
    <td align="center"><b>Not Valid Certificate</b></td>
  <tr>
  <tr>
    <td> <img src="https://user-images.githubusercontent.com/15220788/110632720-8b02c400-81da-11eb-826b-092bd5ffe1e9.gif" alt="SSL Pinning iOS - Valid Certificate" height=640px></td>
    <td> <img src="https://user-images.githubusercontent.com/15220788/110632735-8e964b00-81da-11eb-894a-3363bd3e3c3e.gif" alt="SSL Pinning iOS - Not Valid Certificate" height=640px></td>
 </tr> 
</table>


## 4. Background Screen Caching
* Android
<table>
  <tr>
    <td align="center"><b>Before</b></td>
    <td align="center"><b>After</b></td>
  <tr>
  <tr>
    <td> <img src="https://user-images.githubusercontent.com/15220788/110633491-65c28580-81db-11eb-8d7c-8eed78bc6e7c.png" alt="Default Android in Task Switcher" height=640px></td>
    <td> <img src="https://user-images.githubusercontent.com/15220788/110633510-6a873980-81db-11eb-96ef-b6c9a6a11146.png" alt="Prevent Background Screen Caching - Android" height=640px></td>
 </tr> 
</table>

* iOS
<table>
  <tr>
    <td align="center"><b>Before</b></td>
    <td align="center"><b>After</b></td>
  <tr>
  <tr>
    <td> <img src="https://user-images.githubusercontent.com/15220788/110633720-af12d500-81db-11eb-86d6-986f61f5d42b.gif" alt="Default iOS in Task Switcher" height=640px></td>
    <td> <img src="https://user-images.githubusercontent.com/15220788/110633789-c225a500-81db-11eb-97b0-c27aec9f2a40.gif" alt="Prevent Background Screen Caching - iOS" height=640px></td>
 </tr> 
</table>


## 5. NSAllowArbitaryLoads
<img width="1180" alt="Screen Shot 2021-03-10 at 15 04 05" src="https://user-images.githubusercontent.com/15220788/110633803-c5b92c00-81db-11eb-82e6-0c63e50989b5.png">

