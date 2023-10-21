<a name="top"></a>

<h1 align="center">
  <strong><span>Bootcamp Desarrollo de Apps Móviles</span></strong>
</h1>

---

<p align="center">
  <strong><span style="font-size:20px;">Módulo: iOS avanzado 🍏</span></strong>
</p>

---

<p align="center">
  <strong>Autor:</strong> Salva Moreno Sánchez
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/salvador-moreno-sanchez/">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
  </a>
</p>

## Índice
 
* [Herramientas](#herramientas)
* [Práctica: Dragon Ball Heroes App](#practica)
	* [Descripción](#descripcion)
	* [Arquitectura](#arquitectura)
	* [Diseño](#diseno)
	* [Requisitos](#requisitos)
		* [Obligatorios](#requisitosObligatorios)
		* [Opcionales](#requisitosOpcionales) 
	* [Características adicionales de mejora](#caracteristicas)
	* [Problemas, decisiones y resolución](#problemas)
		* [Añadir gradiente a vista específica dentro de una `UITableViewCell`](#problemas1)

<a name="herramientas"></a>
## Herramientas

<p align="center">

<a href="https://www.apple.com/es/ios/ios-17/">
   <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS">
 </a>
  
 <a href="https://www.swift.org/documentation/">
   <img src="https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white" alt="Swift">
 </a>
  
 <a href="https://developer.apple.com/xcode/">
   <img src="https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white" alt="XCode">
 </a>
  
</p>

<a name="practica"></a>
## Práctica: Dragon Ball Heroes App

![Demo app gif](images/demoApp.gif)

<a name="descripcion"></a>
### Descripción

Como práctica final al módulo de *Fundamentos iOS* del *Bootcamp* en Desarrollo de Apps Móviles, se nos ha propuesto el desarrollo de una **aplicación iOS siguiendo la arquitectura MVC que consuma la *API Rest Dragon Ball* de *KeepCoding*,** con el objetivo de poner a prueba los contenidos impartidos.

<a name="arquitectura"></a>
### Arquitectura

* According to [uncle Bob's Clean Architecture pattern](https://blog.cleancoder.com/uncle-bob/2011/11/22/Clean-Architecture.html), you may divide your code in 3 Layers :

	* Presentation : All Code which is Framework ( Cocoa here ) dependant. So Put your Views, ViewModels, Vierwcontrollers, etc.
	* Data : All the code interacting with repositories ( Like Network Calls, DB calls, User Defaults, etc )
	* Domain : All your Models

<a name="diseno"></a>
### Diseño

* Celdas `UITableView` animadas.

<a name="requisitos"></a>
### Requisitos

<a name="requisitosObligatorios"></a>
#### Obligatorios

1. La aplicación será desarrollada siguiendo la **arquitectura MVC**.
2. No usar *storyboards*, preferiblemente `.xibs`.
3. La aplicación contará con las siguientes pantallas:
	1. **Login**, que permita identificar a un usuario.
	2. **Listado de heroes**, que liste todos los heroes. Se podrá escoger entre `UITableViewController` y `UICollectionViewController`.
	3. **Detalle de héroe**, que represente algunas de las propiedades del héroe y que contenga un botón para mostrar el listado de transformaciones.
	4. **Lista de transformaciones del héroe**, que liste todas las transformaciones disponibles para ese héroe.
4. El proyecto debe **incluir *Unit Test* para la capa de modelo**.

<a name="requisitosOpcionales"></a>
#### Opcionales

1. **Mostrar/esconder el botón de transformaciones en el detalle de héroe**. Si el héroe cuenta con transformaciones, el botón será mostrado. Si el héroe no cuenta con transformaciones, debemos esconder el botón.
2. **Detalle de transformación**, que represente algunas de las propiedades de la transformación.

<a name="caracteristicas"></a>
### Características adicionales de mejora

<a name="problemas"></a>
### Problemas, decisiones y resolución

<a name="problemas1"></a>
#### Añadir gradiente a vista específica dentro de una `UITableViewCell`

Tuve un momento bloqueante al no conseguir la adicción de un gradiente a la `cardView` de la celda personalizada del `UITableView`. Al inicio, obtuve el gradiente como yo deseaba, incluyendo en la función `layoutSubviews` la configuración del gradiente; sin embargo, cada vez que realizaba *scroll* o pulsaba sobre la celda, el gradiente volvía a inicializarse y se iban acumulando constantemente gradientes.

Esto se debía solucionar agregando la configuración al `init` de la celda para que sólo se inicialice el gradiente una sola vez. No obstante, esto no funcionaba ya que no se aplicaba el gradiente a la vista `cardView` porque su tamaño no estaba aún establecido en ese punto del código.

De esta forma, realizando un proceso de *debug*, pude percatarme de la evolución que tenía el tamaño de la `cardView` a lo largo de la manipulación de la aplicación en el simulador y vi que parecía evidente que la solución pasaba por esperar que el tamaño de la `cardView` no fuera 0 y, además, debíamos asegurarnos que la gradiente solo se inicializara una sola vez para evitar acumulaciones y superposiciones.

Así quedaría la `UITableViewCell` para conseguir la solución:

```swift
final class SearchTableViewCell: UITableViewCell {
    // ...
    
    private var gradientAdded = false
    
    // ...
    
    public func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.systemOrange.cgColor
        ]
        gradientLayer.locations = [0.01, 0.1, 0.7, 1.0]
        gradientLayer.frame = cardView.bounds
        gradientLayer.cornerRadius = 20
        cardView.layer.addSublayer(gradientLayer)
    }
   
   	// ...
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = cardView.bounds
        
        if !gradientAdded && cardView.bounds != .zero {
            addGradient()
            gradientAdded = true
        }
    }
    
    // ...
    
}
```

<a name="problemas2"></a>
#### Comportamiento inesperado `UICollectionViewCell`: la imagen y el gradiente aparecen en celdas que no se ven en pantalla y cuando pulsas en ellas, aparecen

---

# Inspiración

* [Dragon Ball Z PROTOTYPE APP](https://dribbble.com/shots/22234085-Dragon-Ball-Z-Character-Info)
* Foto de <a href="https://unsplash.com/es/@jeetdhanoa?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Jeet Dhanoa</a> en <a href="https://unsplash.com/es/fotos/sR1BaDlRSKM?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash -> https://unsplash.com/es/fotos/sR1BaDlRSKM</a>
* Foto de <a href="https://unsplash.com/es/@sysoda?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Sysoda Chau</a> en <a href="https://unsplash.com/es/fotos/sMen1eul9dE?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash -> https://unsplash.com/es/fotos/sMen1eul9dE</a>
* [How to create CUSTOM TABBAR (simple to advanced) using swift 5](https://www.youtube.com/watch?v=_N4lxebmJ2U)

---

[Subir ⬆️](#top)

---
