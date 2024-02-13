import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { ReservationFormComponent } from './reservation-form/reservation-form.component';
import { ReservationListComponent } from './reservation-list/reservation-list.component';

const routes: Routes = 
[
  {path:"",component : HomeComponent} ,                  //http://localhost:4200//paths is empty as is the home url and the component detched is homecomponent
  {path:"new",component : ReservationFormComponent},     //http://localhost:4200/new
  {path:"list",component : ReservationListComponent},    //http://localhost:4200/list
  {path:"edit/:id",component : ReservationFormComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
