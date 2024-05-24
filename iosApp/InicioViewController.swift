//
//  InicioViewController.swift
//  iosApp
//
//  Created by Rogelio on 4/19/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InicioViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var juego: UITextField!
    @IBOutlet weak var genero: UITextField!
    @IBOutlet weak var vistaPicker: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    var plataforma:String = ""
    let plataformas = ["PLAYSTATION 4", "XBOX ONE", "NINTENDO SWITCH", "PC"]
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        let correo = Auth.auth().currentUser?.email
        print("Correo del usuario es: \(correo!)")
        ref = Database.database().reference()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return plataformas[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return plataformas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        plataforma = plataformas[row]
        vistaPicker.text = plataformas[row]
    }

    @IBAction func guardar(_ sender: UIButton){
        guard let id = ref.childByAutoId().key else {
            print("Error: No se pudo obtener el ID")
            return
        }
        
        guard let juegoText = juego.text, !juegoText.isEmpty else {
            print("Error: El campo 'juego' está vacío")
            return
        }
        
        guard let generoText = genero.text, !generoText.isEmpty else{
            print("Error: El campo 'genero' está vacío")
            return
        }
        
        let campos = ["nombre": juegoText,
                      "genero": generoText,
                      "id": id]
        
        ref.child(plataforma).child(id).setValue(campos) {
            error, _ in
            if let error = error{
                print("Error al guardar: \(error.localizedDescription)")
            }else{
                print("Guardado")
                self.limpiar()
            }
        }
       
    }
    
    @IBAction func salir(_ sender: Any) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "login", sender: self)
    }
    
    func limpiar(){
        juego.text = ""
        genero.text = ""
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
