import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup,Validators } from '@angular/forms';
import { ReservationService } from '../reservation/reservation.service';
import { Reservation } from '../models/reservation';
import { Router , ActivatedRoute} from '@angular/router';

@Component({
  selector: 'app-reservation-form',
  templateUrl: './reservation-form.component.html',
  styleUrl: './reservation-form.component.css'
})
export class ReservationFormComponent implements OnInit
{
  reservationForm : FormGroup = new FormGroup ({})                        //inside our class we need a formgroup which we can bind to the form template in the HTML

  constructor
  (private formBuilder : FormBuilder,
   private reservationService : ReservationService,
   private router :Router,
   private activatedRoute : ActivatedRoute)                          // a constructor is a method that gets called /started/invoked in the moment and we create an instance of the class, so the moment we create and instance of our reservation form component the constructor will get invoked and we want to have a form builder, so we write down a provate form , builder of type form builder to get injected into our reservation form component, dependancy injection basically menas the we have a system in angular that says that our reservation form component now wants to have a form builder 
  {
    //we are creating an instance of FormBuilder which is  formBuilder which is of type FormBuilder
  }
  
  ngOnInit(): void   // we are using the oninit for checking of the validation purpose
  {
    this.reservationForm = this.formBuilder.group                          //reservationForm we are using this property and grouping all the in put fields and checking for the validation using the group property
    (
      {
      checkInDate: ['', Validators.required],
      checkOutDate : ['',Validators.required],
      guestName : ['',Validators.required],
      guestEmail : ['',Validators.required],
      roomNumber : ['',Validators.required],
      }
    )
    let id = this.activatedRoute.snapshot.paramMap.get('id')
    if (id)
    {
      let reservation =this.reservationService.getReservation(id)
      if(reservation)
      this.reservationForm.patchValue(reservation)
    }
  } 

  onSubmit()
  {
    if (this.reservationForm.valid)      
    {
      console.log("valid")
      let reservation: Reservation = this.reservationForm.value;

      let id = this.activatedRoute.snapshot.paramMap.get('id')
      if (id)
      {
        this.reservationService.updateReservation(id , reservation)
      }
      else
      {
        this.reservationService.addReservation(reservation)

      }


      this.reservationService.addReservation(reservation);

      this.router.navigate(['/list'])
    }
  //   else
  //   {
  //       alert("Please enter all fields to continue")
  //   }
  }

}
