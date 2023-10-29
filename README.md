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
		* [Comportamiento inesperado `UICollectionViewCell`: la imagen y el gradiente aparecen en celdas que no se ven en pantalla y cuando pulsas en ellas, aparecen](#problemas2)
		* [`UILabel` sobre gradiente](#problemas3)
		* [Mala adjudicación del tag del `UIButton` cada vez que se creaba una `annotation` en la función `mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?` del `MKMapViewDelegate`](#problemas4)

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

Situación bloqueante a la que no encontré solución rápida, ya que creía haber implementado todo correctamente y, además, buscando información no encontraba la manera de resolverlo.

Aunque a ciencia cierta no sé con seguridad qué ocurría, he sacado algunas conclusiones de lo que podía suceder:

- Uso de varias capas y `UIView` que podían provocar superposición en algún momento del ciclo de vida de la vista.
- Empleo de `layoutSubviews()`, el cual se ejecuta cada vez que se carga o reusa una celda. Este método puede dar problemas cuando se usan varias capas, como me ocurrió en el problema anterior con el gradiente, el cual se superponía y acumulaba cada vez que interactuaba o reusaba una celda, provocando un efecto y comportamiento incorrectos.
- Que se cargara la imagen antes que alguna `UIView`, lo cual provocaba que no se viera.

Sin embargo, el análisis de estos casos y su respectivo cambio en el código, no me producía ningún avance, seguía obteniendo el mismo resultado.

Hasta que decidí probar a, en vez de posicionar la imagen en el `layoutSubviews()` con los `bounds` de la `UIView`, situar la imagen a través de *constraints*, consiguiendo el resultado que yo deseaba y evitando el mal comportamiento del `UICollectionView` con respecto a la aparición de la imagen.

<a name="problemas3"></a>
#### `UILabel` sobre gradiente

Al posicionar mi `UILabel` correctamente dentro de una `UIView` con una gradiente, tenía el problema de que la `UILabel` se colocaba dentrás de la gradiente.

La solución es simple: agregar la `UILabel` después de añadir la gradiente al `UIView`.

```swift
override func layoutSubviews() {
    super.layoutSubviews()
    
    // ...
    
	addGradient()
	cardView.addSubview(heroNameLabel)
}
```

Además, no debemos olvidar volver a agregar el `UILabel` también cuando inicializamos todas las vistas en general.

```swift
private func addViews() {
    // ...
    cardView.addSubview(heroNameLabel)
}
```

<a name="problemas4"></a>
#### Mala adjudicación del tag del `UIButton` cada vez que se creaba una `annotation` en la función `mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?` del `MKMapViewDelegate` 

A pesar de poder navegar al detalle del personaje empleando el método `didSelect` del `MKMapViewDelegate`, no me gustaba el efecto que realizaba ya que navegaba directamente sin que el usuario pudiera saber a qué pertenece ese *pin* en el mapa y pudiera decidir si quiere ampliar información.

Por tanto, decidí crear un botón personalizado a la derecha del nombre del personaje para que, así, el usuario tuviera la capacidad de elegir si quiere o no saber más. Sin embargo, tuve problemas con la adjudicación del modelo del héroe a cada botón una vez que se instanciaba.

Cuando lo desarrollé por primera vez, el comportamiento era correcto con los *pins* que se inicializaban por primera vez en el mapa; pero, a la hora de inicializar aquellos que se reusaban, no estaba aportándole al botón un *tag* al botón `rightButton` cuando `annotationView` era `nil`. Esto sucedía en el bloque `if` del código. Así que cuando navegaba por el mapa y encontraba *pins* que no se habían inicializado al aparecer la vista completa, navegaba al detalle de un héroe que no era el correcto.

Se quería asignar un *tag* al botón incluso cuando el código entrara en la parte del `else`, es decir, cuando `annotationView` no era `nil`, por lo que se movió la lógica de asignación del *tag* y la adición de la anotación fuera de las condiciones `if` y `else`. De esta manera, independientemente de si `annotationView` es `nil` o no, se asignará el *tag* al botón `rightButton`.

Esto significa que ahora se está asignando un *tag* a `rightButton` tanto en el caso de que `annotationView` sea `nil` (cuando se crea una nueva vista de anotación) como en el caso de que no lo sea (cuando se reutiliza una vista de anotación existente).

---

# A mejorar

 // los números deberían estar en variables constantes!! y no hardcodearlos
 // los textos no deberían ir a fuego, deberían ir en un archivo localizable y traducido a otros idiomas

---

[Subir ⬆️](#top)

---
