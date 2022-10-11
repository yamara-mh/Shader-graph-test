using UnityEngine;

namespace DecalShadow
{
    public class SineMoveY : MonoBehaviour
    {
        void Update()
        {
            transform.position = Vector3.up * (2f + Mathf.Sin(Time.time * 2f));
            transform.rotation = Quaternion.Euler(Time.time * 60f, Time.time * 120f, Time.time * 180f);
        }
    }
}