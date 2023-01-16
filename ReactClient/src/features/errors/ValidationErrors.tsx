interface Props{
    errors: string[];
}

export default function ValidationErrors({errors}: Props){
    return (
        <div>
            {errors && (errors.map((err:any, i)=>(
                <div key={i} className="text-danger">{err}</div>
            )))}
        </div>
    );
}