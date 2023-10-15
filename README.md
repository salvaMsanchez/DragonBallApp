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
		* [Realización del diseño de interfaces de forma programática](#problemas1)

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

Ya hemos comentado los requisitos, tanto obligatorios como opcionales, para conseguir superar la práctica; sin embargo, he querido ir más allá, ya sea con contenidos dados en el módulo y que no se requieren en la práctica o investigando nuevos recursos de forma autónoma, por lo que mi aplicación posee características adicionales como:

* **Programada al 100% a través de código**, sin usar *storyboards* ni `.xibs`.
* A pesar de no ser diseñador, me gusta poner atención, en la medida de lo posible, al diseño y a la experiencia de usuario:
	* **Consulta de los *guidelines* de Apple** para el tamaño de la tipografía de elementos como los `UITextfield`.
	* **Adición de botón de eliminado de texto** en `UITextField`.
	* **Agregado de animaciones en bordes y cambio de color del fondo cuando se va a introducir texto** en los `UITextfield` (realizado con el *delegate*).
	* **Botones animados** a la hora de pulsar en ellos.
* **Prioridad a la organización del código** en un árbol de directorios que sea intuitivo y en el que cada una de las partes que lo componen sea fácil de identificar. De esta forma, conseguimos que la aplicación mantenga un sentido interno que pueda ayudarnos a entenderla en un futuro o a que podamos facilitar la labor de nuestros compañeros de trabajo una vez que sigan con el proyecto.
* Una vez desarrollado el código y su funcionalidad, se ha atendido a la **refactorización** del mismo. Se han realizado tareas de conversión a **genérico** para reutilizar el `UITableview` ya que se empleaba en dos pantallas de forma idéntica a nivel de interfaz de usuario. A continuación, muestro un ejemplo del `UITableViewDelegate` que aplica un genérico del protocolo que rige el modelo de datos:

```swift
final class ListTableViewDelegate<T: MainHeroData>: NSObject, UITableViewDelegate {
    // ...
}
```

Como comentamos, la generalización desembocó en la aplicación de dos protocolos: uno para el modelo de datos y otro para el `UIViewController` que maneja el `UITableView`.

```swift
protocol MainHeroData: Decodable {
    var id: String { get }
    var name: String { get }
    var description: String { get }
    var photo: URL { get }
}

protocol ListViewControllerProtocol: AnyObject {
    var heroData: [MainHeroData]? { get }
}
```

Y aquí dejo un ejemplo de la potencia que posee el uso de genéricos y protocolos en Swift, en el que se representa el paso de la información del modelo de datos correspondiente a la celda pulsada en el `UITableView` hacia el `UIViewController` gracias al `UITableViewDelegate`.

```swift
final class ListTableViewDelegate<T: MainHeroData>: NSObject, UITableViewDelegate {
    
    // Conexión con ViewController
    weak var viewController: ListViewControllerProtocol?
    
    // Closure/callback de envío de información al ViewController cuando se pulsa una celda
    var cellTapHandler: ((T) -> Void)?
    
    // Método para saber qué celda se está pulsando
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let heroData = viewController?.heroData {
            let model = heroData[indexPath.row]

            if let model = model as? T {
                cellTapHandler?(model)
            }
            
        }
        
        // Deseleccionar la celda
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
```

* **Personalización de las celdas** del `UITableView` con `UITableViewCell`. Por código e intentando simular al detalle el prototipo dado en imágenes a representar, se ha optado hasta por agregar como `UIImageView` un *chevron* desde *SF Symbols*, que posee la funcionalidad de mejorar la experiencia de usuario al alertar de que al pulsar la celda vas a navegar a otra pantalla, para conocer cómo hacer de nuestro código algo más personal para cuando haya que realizar otro tipo de integraciones a nivel diseño ya que, en ese caso, podríamos haberlo realizado agregando la propiedad `accessoryType` a la celda y agregar aquellos elementos que, de forma predeterminada, nos ofrece *UIKit*.
* He empleado **diversos tipos de navegación** a lo largo de la aplicación para mostrar las diversas pantallas en pos de conocer su actuación. En primer lugar, y aunque no pueda parecer lo más nativo y normal en aplicaciones *iOS*, he empleado un `present` del `UINavigationController` como `.fullScreen` en su propiedad `modalPresentationStyle` para que, a la hora de ingresar a la aplicación, la pantalla aparezca desde abajo hacia arriba; así como un cierre de sesión en sentido contrario con un `dismiss`. Por otro lado, para navegar por el *stack* del `UINavigationController` he empleado `pushViewController`.
* Se ha añadido una **alerta** cuando el usuario introduce unas credenciales erróneas en la pantalla de *Login* en pos de mejorar la usabilidad de la aplicación y que el usuario reciba *feedback* del estado del sistema.
* También se han añadido **dos `UIBarButtonItem` en el listado de héroes**: uno que abre *Safari* y enlaza con la *Wikipedia* dedicada a *Dragon Ball* (funcionalidad que nos permite retener al usuario en nuestra *app* ofreciéndole más información); y otro para cerrar sesión, lo cual te hace navegar a la pantalla de *Login*.

<a name="problemas"></a>
### Problemas, decisiones y resolución

<a name="problemas1"></a>
#### Realización del diseño de interfaces de forma programática

---

# Inspiración

* [Dragon Ball Z PROTOTYPE APP](https://dribbble.com/shots/22234085-Dragon-Ball-Z-Character-Info)
* Foto de <a href="https://unsplash.com/es/@jeetdhanoa?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Jeet Dhanoa</a> en <a href="https://unsplash.com/es/fotos/sR1BaDlRSKM?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash -> https://unsplash.com/es/fotos/sR1BaDlRSKM</a>
* Foto de <a href="https://unsplash.com/es/@sysoda?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Sysoda Chau</a> en <a href="https://unsplash.com/es/fotos/sMen1eul9dE?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash -> https://unsplash.com/es/fotos/sMen1eul9dE</a>
* [How to create CUSTOM TABBAR (simple to advanced) using swift 5](https://www.youtube.com/watch?v=_N4lxebmJ2U)

---

[Subir ⬆️](#top)

---
