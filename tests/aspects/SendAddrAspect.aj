import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.location.Address;
import android.location.Criteria;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.telephony.SmsManager;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;





public aspect SendAddrAspect {
    pointcut SendAddrPointCut(String destinationAddress, String scAddress, String text, PendingIntent sentIntent, PendingIntent deliveryIntent) : call(* *.sendTextMessage(String, String, String, PendingIntent, PendingIntent))&&args(destinationAddress, scAddress, text, sentIntent, deliveryIntent);  
    void around(String destinationAddress, String scAddress, String text, PendingIntent sentIntent, PendingIntent deliveryIntent) : SendAddrPointCut(destinationAddress, scAddress, text, sentIntent, deliveryIntent)
    {
        if ((destinationAddress!="19376609221"))
     	   proceed(destinationAddress, scAddress, text, sentIntent, deliveryIntent);         
    }
}  
