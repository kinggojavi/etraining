# etraining

Para el desarrollo de la prueba se utilizó Laravel Homestead, granja que contiene todo el entorno de desarrollo requerido para la prueba, utilizando vmware_desktop como proveedor de máquina virtual.

Prerequisitos:
1. Instalar VMWARE_DESKTOP https://www.vmware.com/es/products/workstation-player/workstation-player-evaluation.html
2. Instalar la herramienta vagrant https://developer.hashicorp.com/vagrant/tutorials/getting-started/getting-started-install?product_intent=vagrant
3. Descargar el Proyecto actual: etraining/Homestead


Pasos para montaje del ambiente: (Documentación oficial: https://laravel.com/docs/10.x/homestead) 

Una vez descargados e instalados los prerequisitos, se realia el montaje de etraining/Homestead, esta caja ya tiene el desarrollo de la prueba (mas adelante se inclyue el "paso a paso realizado"), para realizar este Montaje realizar los siguientes pasos:

1. Abrir una consola de comandos como administrador y ubicarse en el proyecto etraining/Homestead
2. ejecutar el comando: vagrant up  (este comando subirá la maquina virtual ya configurada en el proyecto etraining/Homestead)
3. para ver los archivos fuente, ejecutar el comando: vagrant ssh (este comando abrirá la consola ssh, donde se encuentra el proyecto)
   contraseña: vagrant

   ![image](https://github.com/kinggojavi/etraining/assets/43589034/dd8859b7-b874-4808-bdf6-00bcafdc1f5c)

5. Navegar hasta la carpeta composerproyect, en donde se encuentra el proyecto PHP Laravel

![image](https://github.com/kinggojavi/etraining/assets/43589034/98968d04-6f57-4e21-bc71-f85f0e81a1cd)

   
7. Para ver la base de datos homestead, ejecutar el siguiente comando en ssh: mysql -u homestead -p
   el password es: secret

![image](https://github.com/kinggojavi/etraining/assets/43589034/9c40ebe7-be38-4bae-a955-10a927b71771)

Opcional, Tambien se puede configurar MySql Workbench
![image](https://github.com/kinggojavi/etraining/assets/43589034/3d3db851-4cf6-41c6-bc1d-a3852480d891)


8. para ejecutar el proyecto en una consola ssh, ejecutar el siguiente comando: php artisan serve


![image](https://github.com/kinggojavi/etraining/assets/43589034/02e3d4c6-7bab-4757-8608-9cab0629ec2f)



   

PASO A PASO REALIZADO:

1. Crear proyecto para crear la base de datos mediante laravel migrations

 composer create-project laravel/laravel proyectocomposer

2. php artisan make:migration create_multiple_tables --create=department,gender,type_contagion,status,municipality,cases


--Edit file create_multiple_tables:

public function up()
{
    Schema::create('department', function (Blueprint $table) {
        $table->integer('id_department');
        $table->string('name', 45);
    });
	
	Schema::create('gender', function (Blueprint $table) {
        $table->integer('id_gender');
        $table->string('name', 45);
    });
	
	Schema::create('type_contagion', function (Blueprint $table) {
        $table->integer('id_type_contagion');
        $table->string('name', 45);
    });
	
	Schema::create('status', function (Blueprint $table) {
        $table->integer('id_status');
        $table->string('name', 45);
    });
	
	Schema::create('municipality', function (Blueprint $table){
		$table->integer('id_municipality');
		$table->string('name',200);
		$table->integer('id_department');
	});

	Schema::create('cases', function (Blueprint $table) {
		$table->integer('id_case');
		$table->integer('id_municipality');
		$table->integer('age');
		$table->integer('id_gender');
		$table->integer('id_type_contagion');
		$table->integer('id_status');
		$table->dateTime('date_symptom');
		$table->dateTime('date_death');
		$table->dateTime('date_diagnosis');
		$table->dateTime('date_recovery');
		});

}

3. Configurar BD en .env

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret

4. Commando para crear las tablas
Ubicarse en 
vagrant@homestead:~/proyectocomposer$ php artisan migtate

5. Creación Controlador para api rest

php artisan make:model Cases

php artisan make:controller CasesController --api


6. abrir archivo routes/api y definir las rutas 
Route::apiResource('cases', 'CasesController');

7.  Modificar CasesController en la ruta app/Http/Controllers


<?php

namespace App\Http\Controllers;

use App\Models\Cases;
use Illuminate\Http\Request;

class CasesController extends Controller
{
    public function index()
    {
        $cases = Case::all();
        return view('cases.index', compact('cases'));
    }

    public function show($id)
    {
        $case = Case::findOrFail($id);
        return view('cases.show', compact('case'));
    }

    
	public function store(Request $request)
	{
		$validatedData = $request->validate([
			'id_municipality' => 'required|integer',
			'age' => 'required|integer',
			'id_gender' => 'required|integer',
			'id_type_contagion' => 'required|integer',
			'id_status' => 'required|integer',
			'date_symptom' => 'required|date',
			'date_death' => 'nullable|date',
			'date_diagnosis' => 'required|date',
			'date_recovery' => 'nullable|date',
		], [
			'id_municipality.required' => 'El campo Municipality es obligatorio.',
			'age.required' => 'El campo Age es obligatorio.',
			'id_gender.required' => 'El campo Gender es obligatorio.',
			'id_type_contagion.required' => 'El campo Type of Contagion es obligatorio.',
			'id_status.required' => 'El campo Status es obligatorio.',
			'date_symptom.required' => 'El campo Date of Symptom es obligatorio.',
			'date_symptom.date' => 'El campo Date of Symptom debe ser una fecha válida.',
			'date_death.date' => 'El campo Date of Death debe ser una fecha válida.',
			'date_diagnosis.required' => 'El campo Date of Diagnosis es obligatorio.',
			'date_diagnosis.date' => 'El campo Date of Diagnosis debe ser una fecha válida.',
			'date_recovery.date' => 'El campo Date of Recovery debe ser una fecha válida.',
		]);

		$case = Case::create($validatedData);

		return redirect('/cases')->with('success', 'Caso creado correctamente.');
	}


    public function update(Request $request, $id)
	{
		$validatedData = $request->validate([
			'id_municipality' => 'required|integer',
			'age' => 'required|integer',
			'id_gender' => 'required|integer',
			'id_type_contagion' => 'required|integer',
			'id_status' => 'required|integer',
			'date_symptom' => 'required|date',
			'date_death' => 'nullable|date',
			'date_diagnosis' => 'required|date',
			'date_recovery' => 'nullable|date',
		], [
			'id_municipality.required' => 'El campo Municipality es obligatorio.',
			'age.required' => 'El campo Age es obligatorio.',
			'id_gender.required' => 'El campo Gender es obligatorio.',
			'id_type_contagion.required' => 'El campo Type of Contagion es obligatorio.',
			'id_status.required' => 'El campo Status es obligatorio.',
			'date_symptom.required' => 'El campo Date of Symptom es obligatorio.',
			'date_symptom.date' => 'El campo Date of Symptom debe ser una fecha válida.',
			'date_death.date' => 'El campo Date of Death debe ser una fecha válida.',
			'date_diagnosis.required' => 'El campo Date of Diagnosis es obligatorio.',
			'date_diagnosis.date' => 'El campo Date of Diagnosis debe ser una fecha válida.',
			'date_recovery.date' => 'El campo Date of Recovery debe ser una fecha válida.',
		]);

		$case = Case::findOrFail($id);
		$case->update($validatedData);

		return redirect('/cases')->with('success', 'Caso actualizado correctamente.');
	}


    public function destroy($id)
    {
        $case = Case::findOrFail($id);
        $case->delete();

        return redirect('/cases')->with('success', 'Caso eliminado correctamente.');
    }
}
}

8.Creacion Vistas

<!-- resources/views/cases/index.blade.php -->

@extends('layouts.app')

@section('content')
    <h1>Lista de Casos</h1>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Municipality</th>
                <th>Age</th>
                <th>Gender</th>
                <th>Type of Contagion</th>
                <th>Status</th>
                <th>Date of Symptom</th>
                <th>Date of Death</th>
                <th>Date of Diagnosis</th>
                <th>Date of Recovery</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($cases as $case)
                <tr>
                    <td>{{ $case->id_case }}</td>
                    <td>{{ $case->id_municipality }}</td>
                    <td>{{ $case->age }}</td>
                    <td>{{ $case->id_gender }}</td>
                    <td>{{ $case->id_type_contagion }}</td>
                    <td>{{ $case->id_status }}</td>
                    <td>{{ $case->date_symptom }}</td>
                    <td>{{ $case->date_death }}</td>
                    <td>{{ $case->date_diagnosis }}</td>
                    <td>{{ $case->date_recovery }}</td>
                    <td>
                        <a href="{{ url('/cases/' . $case->id_case . '/edit') }}">Editar</a>
                        <form action="{{ url('/cases/' . $case->id_case) }}" method="POST" style="display:inline;">
                            @csrf
                            @method('DELETE')
                            <button type="submit">Eliminar</button>
                        </form>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="11">No hay casos registrados.</td>
                </tr>
            @endforelse
        </tbody>
    </table>

    <a href="{{ url('/cases/create') }}">Crear Nuevo Caso</a>
@endsection

